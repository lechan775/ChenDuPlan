import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { currentUser } from '../data/CurrentUser';
import { showToast, routerBack } from '../utils/UiFeedback';

interface WrongWord {
  id: number;
  word: string;
  meaning: string;
  bookTitle: string;
  wrongCount: number;
  lastWrongAt: string;
  sentence: string;
  reason: string;
}

interface WrongWordApiItem {
  id: number;
  userId: number;
  wordId: number;
  word: string;
  meaning: string;
  bookTitle: string;
  wrongCount: number;
  lastWrongAt: string;
  sentenceText: string;
  reasonText: string;
}

interface WrongWordApiResponse {
  code: number;
  message: string;
  data: WrongWordApiItem[] | null;
}

interface SimpleResultResponse {
  code: number;
  message: string;
  data: string | null;
}

@Entry
@Component
struct WrongBookPage {
  @State records: WrongWord[] = [];
  @State isLoading: boolean = false;
  @State deletingId: number = 0;

  loadWrongWords() {
    this.isLoading = true;
    ApiService.get('/api/wrong-words?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as WrongWordApiResponse;

          if (response.code !== 200 || response.data === null) {
            showToast(this.getUIContext(), response.message);
            this.isLoading = false;
            return;
          }

          const mappedRecords: WrongWord[] = response.data.map((item: WrongWordApiItem): WrongWord => {
            const lastWrongAtText: string = item.lastWrongAt.length >= 16
              ? item.lastWrongAt.slice(0, 16).replace('T', ' ')
              : item.lastWrongAt;

            return {
              id: item.id,
              word: item.word,
              meaning: item.meaning,
              bookTitle: item.bookTitle,
              wrongCount: item.wrongCount,
              lastWrongAt: lastWrongAtText,
              sentence: item.sentenceText,
              reason: item.reasonText
            };
          });

          this.records = mappedRecords;
        } catch (error) {
          const err = error as BusinessError<number>;
          showToast(this.getUIContext(), '错题本数据解析失败');
          console.error('load wrong words parse failed: ' + err.message);
        } finally {
          this.isLoading = false;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.isLoading = false;
        showToast(this.getUIContext(), '错题本加载失败');
        console.error('load wrong words failed: ' + error.message);
      });
  }

  confirmDeleteWrongWord(item: WrongWord) {
    try {
      this.getUIContext().showAlertDialog({
        title: '删除错题',
        message: '确定要从错题本删除 "' + item.word + '" 吗？',
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '删除',
          fontColor: '#DC2626',
          action: () => {
            this.deleteWrongWord(item.id);
          }
        }
      });
    } catch (error) {
      const err = error as BusinessError<number>;
      console.error('show delete wrong word dialog failed: ' + err.message);
    }
  }

  deleteWrongWord(id: number) {
    if (this.deletingId !== 0) {
      return;
    }

    this.deletingId = id;
    ApiService.delete('/api/wrong-words/' + id + '?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as SimpleResultResponse;
          if (response.code !== 200) {
            showToast(this.getUIContext(), response.message);
            return;
          }

          showToast(this.getUIContext(), '删除成功');
          this.loadWrongWords();
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('delete wrong word parse failed: ' + err.message);
        } finally {
          this.deletingId = 0;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.deletingId = 0;
        showToast(this.getUIContext(), '删除失败');
        console.error('delete wrong word failed: ' + error.message);
      });
  }

  build() {

    Column({ space: 16 }) {
      this.pageHeader('错题本')

      Scroll() {
        Column({ space: 14 }) {
          if (this.isLoading) {
            this.loadingState('正在加载错题本...');
          } else if (this.records.length === 0) {
            this.emptyState('暂无错题', '答题错误的单词会自动进入这里，方便你集中复盘。');
          } else {
            ForEach(this.records, (item: WrongWord) => {
            Column({ space: 12 }) {
              Row() {
                Column({ space: 6 }) {
                  Text(item.word)
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#2F2A24')
                  Text(item.meaning)
                    .fontSize(14)
                    .fontColor('#6B6258')
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Text('错误 ' + item.wrongCount + ' 次')
                  .fontSize(12)
                  .fontColor('#DC2626')
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor('#FEE2E2')
                  .borderRadius(14)

                Text('删除')
                  .fontSize(12)
                  .fontColor('#DC2626')
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor('#FFF1F2')
                  .borderRadius(14)
                  .onClick(() => {
                    this.confirmDeleteWrongWord(item);
                  })
              }
              .width('100%')

              Row({ space: 10 }) {
                this.metaTag(item.bookTitle)
                this.metaTag('最近错误 ' + item.lastWrongAt)
              }
              .width('100%')

              Text(item.sentence)
                .width('100%')
                .fontSize(14)
                .lineHeight(22)
                .fontColor('#4B5563')

              Text('错误原因：' + item.reason)
                .width('100%')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#7C6754')
            }
            .width('100%')
            .padding(18)
            .backgroundColor('#FFFDF9')
            .borderRadius(22)
            }, (item: WrongWord) => item.id.toString())
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 24 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF8F3')
    .onAppear(() => {
      this.loadWrongWords();
    })
  }

  @Builder
  metaTag(value: string) {
    Text(value)
      .fontSize(12)
      .fontColor('#7C6754')
      .padding({ left: 10, right: 10, top: 6, bottom: 6 })
      .backgroundColor('#FFF7ED')
      .borderRadius(14)
  }

  @Builder
  loadingState(message: string) {
    Column({ space: 12 }) {
      LoadingProgress()
        .width(36)
        .height(36)
        .color('#F97316');
      Text(message)
        .fontSize(14)
        .fontColor('#7C6754');
    }
    .width('100%')
    .padding({ top: 42, bottom: 42 })
    .backgroundColor('#FFFDF9')
    .borderRadius(24)
  }

  @Builder
  emptyState(title: string, description: string) {
    Column({ space: 10 }) {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
      Text(description)
        .fontSize(13)
        .lineHeight(20)
        .fontColor('#7C6754')
        .textAlign(TextAlign.Center);
    }
    .width('100%')
    .padding({ left: 22, right: 22, top: 42, bottom: 42 })
    .backgroundColor('#FFFDF9')
    .borderRadius(24)
  }

  @Builder
  pageHeader(title: string) {
    Row() {
      Text('< 返回')
        .fontSize(15)
        .fontColor('#F97316')
        .onClick(() => {
          routerBack(this.getUIContext());
        })
      Blank()
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24')
      Blank()
      Text('    ')
        .fontSize(15)
        .opacity(0)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 18, bottom: 12 })
  }
}

@Preview
@Component
struct WrongBookPagePreview {
  build() {
    WrongBookPage();
  }
}

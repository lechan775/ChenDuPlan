import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { currentUser } from '../data/CurrentUser';
import { showToast, routerBack } from '../utils/UiFeedback';

interface NotebookWord {
  id: number;
  word: string;
  meaning: string;
  bookTitle: string;
  masteryLabel: string;
  nextReview: string;
  addedAt: string;
  note: string;
}

interface NotebookWordApiItem {
  id: number;
  userId: number;
  wordId: number;
  word: string;
  meaning: string;
  bookTitle: string;
  masteryLabel: string;
  nextReview: string;
  addedAt: string;
  noteText: string;
}

interface NotebookWordApiResponse {
  code: number;
  message: string;
  data: NotebookWordApiItem[] | null;
}

interface SimpleResultResponse {
  code: number;
  message: string;
  data: string | null;
}

@Entry
@Component
struct CollectionPage {
  @State records: NotebookWord[] = [];
  @State isLoading: boolean = false;
  @State deletingId: number = 0;

  loadNotebookWords() {
    this.isLoading = true;
    ApiService.get('/api/notebook-words?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as NotebookWordApiResponse;

          if (response.code !== 200 || response.data === null) {
            showToast(this.getUIContext(), response.message);
            this.isLoading = false;
            return;
          }

          const mappedRecords: NotebookWord[] = response.data.map((item: NotebookWordApiItem): NotebookWord => {
            const addedAtText: string = item.addedAt.length >= 10 ? item.addedAt.slice(5, 10) : item.addedAt;
            return {
              id: item.id,
              word: item.word,
              meaning: item.meaning,
              bookTitle: item.bookTitle,
              masteryLabel: item.masteryLabel,
              nextReview: item.nextReview,
              addedAt: addedAtText,
              note: item.noteText
            };
          });

          this.records = mappedRecords;
        } catch (error) {
          const err = error as BusinessError<number>;
          showToast(this.getUIContext(), '生词本数据解析失败');
          console.error('load notebook words parse failed: ' + err.message);
        } finally {
          this.isLoading = false;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.isLoading = false;
        showToast(this.getUIContext(), '生词本加载失败');
        console.error('load notebook words failed: ' + error.message);
      });
  }

  confirmDeleteNotebookWord(item: NotebookWord) {
    try {
      this.getUIContext().showAlertDialog({
        title: '删除生词',
        message: '确定要从生词本删除 "' + item.word + '" 吗？',
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '删除',
          fontColor: '#DC2626',
          action: () => {
            this.deleteNotebookWord(item.id);
          }
        }
      });
    } catch (error) {
      const err = error as BusinessError<number>;
      console.error('show delete notebook dialog failed: ' + err.message);
    }
  }

  deleteNotebookWord(id: number) {
    if (this.deletingId !== 0) {
      return;
    }

    this.deletingId = id;
    ApiService.delete('/api/notebook-words/' + id + '?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as SimpleResultResponse;
          if (response.code !== 200) {
            showToast(this.getUIContext(), response.message);
            return;
          }

          showToast(this.getUIContext(), '删除成功');
          this.loadNotebookWords();
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('delete notebook word parse failed: ' + err.message);
        } finally {
          this.deletingId = 0;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.deletingId = 0;
        showToast(this.getUIContext(), '删除失败');
        console.error('delete notebook word failed: ' + error.message);
      });
  }

  build() {

    Column({ space: 16 }) {
      this.pageHeader('我的生词本')

      Scroll() {
        Column({ space: 14 }) {
          if (this.isLoading) {
            this.loadingState('正在加载生词本...');
          } else if (this.records.length === 0) {
            this.emptyState('暂无生词', '背词时点击“加入生词本”，这里会显示需要重点复习的单词。');
          } else {
            ForEach(this.records, (item: NotebookWord) => {
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

                Text(item.masteryLabel)
                  .fontSize(12)
                  .fontColor('#F97316')
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor('#FFF1E6')
                  .borderRadius(14)

                Text('删除')
                  .fontSize(12)
                  .fontColor('#DC2626')
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor('#FEE2E2')
                  .borderRadius(14)
                  .onClick(() => {
                    this.confirmDeleteNotebookWord(item);
                  })
              }
              .width('100%')

              Row({ space: 10 }) {
                this.metaTag(item.bookTitle)
                this.metaTag('加入于 ' + item.addedAt)
                this.metaTag('下次复习 ' + item.nextReview)
              }
              .width('100%')

              Text(item.note)
                .width('100%')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#7C6754')
            }
            .width('100%')
            .padding(18)
            .backgroundColor('#FFFDF9')
            .borderRadius(22)
            }, (item: NotebookWord) => item.id.toString())
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
      this.loadNotebookWords();
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
struct CollectionPagePreview {
  build() {
    CollectionPage();
  }
}

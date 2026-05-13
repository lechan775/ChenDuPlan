import { StudyRecord } from '../data/AppState';
import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { currentUser } from '../data/CurrentUser';
import { showToast, routerBack } from '../utils/UiFeedback';

interface CalendarDay {
  key: string;
  dayNumber: number;
  monthDay: string;
  signed: boolean;
  isToday: boolean;
  inCurrentMonth: boolean;
}

interface StudyRecordApiItem {
  id: number;
  userId: number;
  studyDate: string;
  bookTitle: string;
  newCount: number;
  reviewCount: number;
  correctRate: number;
  finishedWords: number;
  durationMinutes: number;
}

interface StudyRecordApiResponse {
  code: number;
  message: string;
  data: StudyRecordApiItem[] | null;
}

interface StatsOverviewData {
  userId: number;
  totalLearnedWords: number;
  streakDays: number;
  accuracyRate: number;
  reviewDue: number;
  todayFinishedWords: number;
  todayCorrectRate: number;
}

interface StatsOverviewResponse {
  code: number;
  message: string;
  data: StatsOverviewData | null;
}

@Entry
@Component
struct StudyRecordPage {
  @State records: StudyRecord[] = [];
  @State streakDays: number = 0;
  @State totalLearnedWords: number = 0;
  @State accuracyRateText: string = '0%';
  @State recordsLoading: boolean = false;
  @State statsLoading: boolean = false;

  loadStudyRecords() {
    this.recordsLoading = true;
    ApiService.get('/api/study-records?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as StudyRecordApiResponse;

          if (response.code !== 200 || response.data === null) {
            this.recordsLoading = false;
            return;
          }

          const mappedRecords: StudyRecord[] = response.data.map((item: StudyRecordApiItem): StudyRecord => {
            const dayText: string = item.studyDate.length >= 10 ? item.studyDate.slice(5, 10) : item.studyDate;
            return {
              day: dayText,
              bookTitle: item.bookTitle,
              newCount: item.newCount,
              reviewCount: item.reviewCount,
              correctRate: item.correctRate,
              finishedWords: item.finishedWords,
              duration: item.durationMinutes.toString() + ' 分钟'
            };
          });

          this.records = mappedRecords;
        } catch (error) {
          const err = error as BusinessError<number>;
          showToast(this.getUIContext(), '学习记录解析失败');
          console.error('load study records parse failed: ' + err.message);
        } finally {
          this.recordsLoading = false;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.recordsLoading = false;
        showToast(this.getUIContext(), '学习记录加载失败: ' + error.code);
        console.error('load study records failed: ' + error.message);
      });
  }

  loadStats() {
    this.statsLoading = true;
    ApiService.get('/api/stats/overview?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as StatsOverviewResponse;

          if (response.code !== 200 || response.data === null) {
            this.statsLoading = false;
            return;
          }

          this.streakDays = response.data.streakDays;
          this.totalLearnedWords = response.data.totalLearnedWords;
          this.accuracyRateText = response.data.accuracyRate.toString() + '%';
        } catch (error) {
          const err = error as BusinessError<number>;
          showToast(this.getUIContext(), '统计解析失败');
          console.error('load stats parse failed: ' + err.message);
        } finally {
          this.statsLoading = false;
        }
      })
      .catch((error: BusinessError<number>) => {
        this.statsLoading = false;
        showToast(this.getUIContext(), '统计加载失败: ' + error.code);
        console.error('load stats failed: ' + error.message);
      });
  }

  totalFinishedWords(): number {
    let total: number = 0;
    for (let i = 0; i < this.records.length; i++) {
      total += this.records[i].finishedWords;
    }
    return total;
  }

  averageCorrectRate(): string {
    if (this.records.length === 0) {
      return '0%';
    }

    let total: number = 0;
    for (let i = 0; i < this.records.length; i++) {
      total += this.records[i].correctRate;
    }
    return Math.round(total / this.records.length).toString() + '%';
  }

  formatMonthDay(date: Date): string {
    const month: string = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1).toString();
    const day: string = date.getDate() < 10 ? '0' + date.getDate() : date.getDate().toString();
    return month + '-' + day;
  }

  monthTitle(): string {
    const today: Date = new Date();
    return today.getFullYear().toString() + '年' + (today.getMonth() + 1).toString() + '月';
  }

  signedDayList(): string[] {
    const signedDays: string[] = [];
    for (let i = 0; i < this.records.length; i++) {
      signedDays.push(this.records[i].day);
    }
    return signedDays;
  }

  isSignedDay(monthDay: string): boolean {
    const signedDays: string[] = this.signedDayList();
    for (let i = 0; i < signedDays.length; i++) {
      if (signedDays[i] === monthDay) {
        return true;
      }
    }
    return false;
  }

  daysInMonth(year: number, monthIndex: number): number {
    return new Date(year, monthIndex + 1, 0).getDate();
  }

  monthCalendarDays(): CalendarDay[] {
    const today: Date = new Date();
    const year: number = today.getFullYear();
    const monthIndex: number = today.getMonth();
    const firstDay: Date = new Date(year, monthIndex, 1);
    const firstDayOffset: number = (firstDay.getDay() + 6) % 7;
    const monthDays: number = this.daysInMonth(year, monthIndex);
    const previousMonthDays: number = this.daysInMonth(year, monthIndex - 1);
    const days: CalendarDay[] = [];

    for (let i = 0; i < firstDayOffset; i++) {
      const dayNumber: number = previousMonthDays - firstDayOffset + i + 1;
      const currentDate: Date = new Date(year, monthIndex - 1, dayNumber);
      days.push({
        key: 'prev-' + dayNumber.toString(),
        dayNumber: dayNumber,
        monthDay: this.formatMonthDay(currentDate),
        signed: false,
        isToday: false,
        inCurrentMonth: false
      });
    }

    for (let i = 1; i <= monthDays; i++) {
      const currentDate: Date = new Date(year, monthIndex, i);
      const monthDay: string = this.formatMonthDay(currentDate);
      days.push({
        key: monthDay,
        dayNumber: i,
        monthDay: monthDay,
        signed: this.isSignedDay(monthDay),
        isToday: monthDay === this.formatMonthDay(today),
        inCurrentMonth: true
      });
    }

    let trailingDay: number = 1;
    while (days.length % 7 !== 0) {
      const currentDate: Date = new Date(year, monthIndex + 1, trailingDay);
      days.push({
        key: 'next-' + trailingDay.toString(),
        dayNumber: trailingDay,
        monthDay: this.formatMonthDay(currentDate),
        signed: false,
        isToday: false,
        inCurrentMonth: false
      });
      trailingDay += 1;
    }

    return days;
  }

  build() {
    Column({ space: 16 }) {
      this.pageHeader('学习记录');

      Scroll() {
        Column({ space: 14 }) {
          Column({ space: 12 }) {
            Row({ space: 10 }) {
              if (this.statsLoading) {
                this.loadingSummaryCard();
              } else {
                this.streakSummaryCard();
                this.totalSummaryCard();
                this.accuracySummaryCard();
              }
            }
            .width('100%');
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFE7CF')
          .borderRadius(28);

          Column({ space: 14 }) {
            Row() {
              Text('本月打卡日历')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2F2A24');
              Blank();
              Text('连续 ' + this.streakDays + ' 天')
                .fontSize(12)
                .fontColor('#F97316')
                .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                .backgroundColor('#FFF3E6')
                .borderRadius(14);
            }
            .width('100%');

            Text(this.monthTitle())
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#6B6258')
              .width('100%');

            Row() {
              this.weekdayLabel('一');
              this.weekdayLabel('二');
              this.weekdayLabel('三');
              this.weekdayLabel('四');
              this.weekdayLabel('五');
              this.weekdayLabel('六');
              this.weekdayLabel('日');
            }
            .width('100%');

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.monthCalendarDays(), (item: CalendarDay) => {
                this.calendarDayCell(item);
              }, (item: CalendarDay) => item.key + '-' + (item.signed ? 'signed' : 'plain'));
            }
            .width('100%');

            Text('橙色圆点表示当天有学习记录。')
              .fontSize(12)
              .fontColor('#7C6754')
              .width('100%');
          }
          .width('100%')
          .padding(18)
          .backgroundColor('#FFFDF9')
          .borderRadius(24);

          if (this.recordsLoading) {
            this.loadingState('正在加载学习记录...');
          } else if (this.records.length === 0) {
            this.emptyState('暂无学习记录', '完成一次背词练习后，本月日历会点亮对应日期。');
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 24 });
      }
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF8F3')
    .onAppear(() => {
      this.loadStudyRecords();
      this.loadStats();
    });
  }

  @Builder
  loadingSummaryCard() {
    Row({ space: 10 }) {
      LoadingProgress()
        .width(26)
        .height(26)
        .color('#F97316');
      Text('正在加载统计...')
        .fontSize(14)
        .fontColor('#7C6754');
    }
    .width('100%')
    .height(74)
    .padding({ left: 12, right: 12 })
    .backgroundColor('#FFF8F1')
    .borderRadius(18)
    .justifyContent(FlexAlign.Center)
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
    .padding({ top: 34, bottom: 34 })
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
    .padding({ left: 22, right: 22, top: 34, bottom: 34 })
    .backgroundColor('#FFFDF9')
    .borderRadius(24)
  }

  @Builder
  weekdayLabel(label: string) {
    Text(label)
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .fontSize(12)
      .fontColor('#8A6C54');
  }

  @Builder
  calendarDayCell(item: CalendarDay) {
    Column({ space: 6 }) {
      Stack() {
        Column()
          .width(34)
          .height(34)
          .borderRadius(17)
          .backgroundColor(item.signed ? '#F97316' : (item.inCurrentMonth ? '#FFF8F1' : '#FFFDF9'))
          .border({
            width: item.isToday ? 2 : 0,
            color: item.isToday ? '#F2B26A' : '#00000000'
          });

        Text(item.dayNumber.toString())
          .fontSize(13)
          .fontWeight(item.isToday ? FontWeight.Bold : FontWeight.Medium)
          .fontColor(item.signed ? Color.White : (item.inCurrentMonth ? '#6B6258' : '#C9B8A6'));
      }
      .width(36)
      .height(36);

      Column()
        .width(5)
        .height(5)
        .borderRadius(3)
        .backgroundColor(item.signed ? '#F97316' : '#00000000');
    }
    .width('14.2857%')
    .height(54)
    .alignItems(HorizontalAlign.Center);
  }

  @Builder
  summaryCard(label: string, value: string) {
    Column({ space: 6 }) {
      Text(label)
        .fontSize(12)
        .fontColor('#8A6C54');
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
    }
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor('#FFF8F1')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  streakSummaryCard() {
    Column({ space: 6 }) {
      Text('连续学习')
        .fontSize(12)
        .fontColor('#8A6C54');
      Text(this.streakDays.toString() + ' 天')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
    }
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor('#FFF8F1')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  totalSummaryCard() {
    Column({ space: 6 }) {
      Text('累计完成')
        .fontSize(12)
        .fontColor('#8A6C54');
      Text(this.totalLearnedWords.toString() + ' 词')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
    }
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor('#FFF8F1')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  accuracySummaryCard() {
    Column({ space: 6 }) {
      Text('平均正确率')
        .fontSize(12)
        .fontColor('#8A6C54');
      Text(this.accuracyRateText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
    }
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor('#FFF8F1')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  pageHeader(title: string) {
    Row() {
      Text('< 返回')
        .fontSize(15)
        .fontColor('#F97316')
        .onClick(() => {
          routerBack(this.getUIContext());
        });
      Blank();
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24');
      Blank();
      Text('    ')
        .fontSize(15)
        .opacity(0);
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 18, bottom: 12 });
  }
}

@Preview
@Component
struct StudyRecordPagePreview {
  build() {
    StudyRecordPage();
  }
}

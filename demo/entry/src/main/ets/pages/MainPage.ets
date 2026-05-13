import {
  BookCard,
  LearningWord,
  userProfile
} from '../data/AppState';
import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { currentUser, resetCurrentUser } from '../data/CurrentUser';
import { showToast, pushUrl } from '../utils/UiFeedback';

interface ProfileResponseData {
  nickname: string;
  dailyTarget: number;
  signature: string;
  selectedBookId: number;
  totalLearnedWords: number;
  streakDays: number;
  accuracyRate: number;
  reviewDue: number;
}

interface ProfileResponse {
  code: number;
  message: string;
  data: ProfileResponseData | null;
}

interface StatsResponseData {
  totalLearnedWords: number;
  streakDays: number;
  accuracyRate: number;
  reviewDue: number;
  todayFinishedWords: number;
  todayCorrectRate: number;
}

interface StatsResponse {
  code: number;
  message: string;
  data: StatsResponseData | null;
}

interface BookProgressItem {
  id: number;
  title: string;
  levelTag: string;
  description: string;
  totalWords: number;
  learnedWords: number;
  todayNew: number;
  todayReview: number;
  progress: number;
  accentColor: string;
  softColor: string;
}

interface BookProgressResponse {
  code: number;
  message: string;
  data: BookProgressItem[] | null;
}

interface WordApiItem {
  id: number;
  bookId: number;
  word: string;
  phonetic: string;
  meaning: string;
  memoryTip: string;
  exampleText: string;
  translationText: string;
  answer: string;
  difficulty: string;
}

interface WordListResponse {
  code: number;
  message: string;
  data: WordApiItem[] | null;
}

interface WordNextResponse {
  code: number;
  message: string;
  data: WordApiItem | null;
}

interface StudySubmitRequestBody {
  userId: number;
  bookTitle: string;
  wordId: number;
  word: string;
  meaning: string;
  isCorrect: boolean;
  selectedAnswer: string;
  correctAnswer: string;
  sentence: string;
  reason: string;
}

interface NotebookWordAddRequestBody {
  userId: number;
  wordId: number;
  word: string;
  meaning: string;
  bookTitle: string;
  masteryLabel: string;
  nextReview: string;
  noteText: string;
}

interface SimpleResultResponse {
  code: number;
  message: string;
  data: string | null;
}

interface EmptyRequestBody {
}

interface BooleanResultResponse {
  code: number;
  message: string;
  data: boolean | null;
}

interface CountItem {
  id: number;
}

interface CountListResponse {
  code: number;
  message: string;
  data: CountItem[] | null;
}

interface StudyRecordCountItem {
  id: number;
  studyDate: string;
}

interface StudyRecordCountResponse {
  code: number;
  message: string;
  data: StudyRecordCountItem[] | null;
}

function emptyBookCard(bookId: number): BookCard {
  return {
    id: bookId,
    title: '暂无词书',
    levelTag: '未选择',
    description: '请确认后端 books 表有数据，并且网络连接正常。',
    totalWords: 0,
    learnedWords: 0,
    todayNew: 0,
    todayReview: 0,
    streakDays: 0,
    progress: 0,
    accentColor: '#F97316',
    softColor: '#FFF1E6'
  };
}

@Entry
@Component
struct MainPage {
  @State currentTabIndex: number = 0;
  @State selectedBookId: number = userProfile.selectedBookId;
  @State showPracticePage: boolean = false;
  @State practiceMode: string = 'learn';
  @State bookList: BookCard[] = [];
  @State notebookCount: number = 0;
  @State wrongCount: number = 0;
  @State studyRecordCount: number = 0;
  @State totalLearnedWords: number = userProfile.totalLearnedWords;
  @State streakDays: number = userProfile.streakDays;
  @State accuracyRate: number = userProfile.accuracyRate;
  @State reviewDue: number = userProfile.reviewDue;
  @State todayFinishedWords: number = 0;
  @State todayCorrectRate: number = 0;

  loadProfileAndStats() {
    ApiService.get('/api/user/profile?userId=' + currentUser.id)
      .then((result: string) => {
        const response = JSON.parse(result) as ProfileResponse;

        if (response.code === 200 && response.data !== null) {
          userProfile.nickname = response.data.nickname;
          userProfile.dailyTarget = response.data.dailyTarget;
          userProfile.signature = response.data.signature;
          userProfile.selectedBookId = response.data.selectedBookId;
          userProfile.totalLearnedWords = response.data.totalLearnedWords;
          userProfile.streakDays = response.data.streakDays;
          userProfile.accuracyRate = response.data.accuracyRate;
          userProfile.reviewDue = response.data.reviewDue;
          this.totalLearnedWords = response.data.totalLearnedWords;
          this.streakDays = response.data.streakDays;
          this.accuracyRate = response.data.accuracyRate;
          this.reviewDue = response.data.reviewDue;
          this.selectedBookId = response.data.selectedBookId;
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '用户资料加载失败');
        console.error('load profile failed: ' + error.message);
      });

    ApiService.get('/api/stats/overview?userId=' + currentUser.id)
      .then((result: string) => {
        const response = JSON.parse(result) as StatsResponse;

        if (response.code === 200 && response.data !== null) {
          userProfile.totalLearnedWords = response.data.totalLearnedWords;
          userProfile.streakDays = response.data.streakDays;
          userProfile.accuracyRate = response.data.accuracyRate;
          userProfile.reviewDue = response.data.reviewDue;
          this.totalLearnedWords = response.data.totalLearnedWords;
          this.streakDays = response.data.streakDays;
          this.accuracyRate = response.data.accuracyRate;
          this.reviewDue = response.data.reviewDue;
          this.todayFinishedWords = response.data.todayFinishedWords;
          this.todayCorrectRate = response.data.todayCorrectRate;
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '统计数据加载失败');
        console.error('load stats failed: ' + error.message);
      });
  }

  loadBookProgress() {
    ApiService.get('/api/books/progress?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as BookProgressResponse;

          if (response.code !== 200 || response.data === null) {
            return;
          }

          const mappedBooks: BookCard[] = response.data.map((item: BookProgressItem): BookCard => {
            return {
              id: item.id,
              title: item.title,
              levelTag: item.levelTag,
              description: item.description,
              totalWords: item.totalWords,
              learnedWords: item.learnedWords,
              todayNew: item.todayNew,
              todayReview: item.todayReview,
              streakDays: userProfile.streakDays,
              progress: item.progress,
              accentColor: item.accentColor,
              softColor: item.softColor
            };
          });

          this.bookList = mappedBooks;

          const exists: boolean = mappedBooks.some((item: BookCard) => item.id === this.selectedBookId);
          if (!exists && mappedBooks.length > 0) {
            this.selectedBookId = mappedBooks[0].id;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          showToast(this.getUIContext(), '词书数据解析失败');
          console.error('load book progress parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '词书数据加载失败');
        console.error('load book progress failed: ' + error.message);
      });
  }

  loadMineCounts() {
    ApiService.get('/api/notebook-words?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as CountListResponse;
          if (response.code === 200 && response.data !== null) {
            this.notebookCount = response.data.length;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('load notebook count parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('load notebook count failed: ' + error.message);
      });

    ApiService.get('/api/wrong-words?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as CountListResponse;
          if (response.code === 200 && response.data !== null) {
            this.wrongCount = response.data.length;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('load wrong count parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('load wrong count failed: ' + error.message);
      });

    ApiService.get('/api/study-records?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as StudyRecordCountResponse;
          if (response.code === 200 && response.data !== null) {
            const studiedDays: string[] = [];
            for (let i = 0; i < response.data.length; i++) {
              const studyDate: string = response.data[i].studyDate;
              const dayText: string = studyDate.length >= 10 ? studyDate.slice(0, 10) : studyDate;
              if (studiedDays.indexOf(dayText) < 0) {
                studiedDays.push(dayText);
              }
            }
            this.studyRecordCount = studiedDays.length;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('load study record count parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('load study record count failed: ' + error.message);
      });
  }

  build() {
    if (this.showPracticePage) {
      StudyPracticePage({
        selectedBookId: $selectedBookId,
        practiceMode: $practiceMode,
        showPracticePage: $showPracticePage,
        bookList: $bookList,
        totalLearnedWords: $totalLearnedWords,
        streakDays: $streakDays,
        accuracyRate: $accuracyRate,
        reviewDue: $reviewDue,
        todayFinishedWords: $todayFinishedWords,
        todayCorrectRate: $todayCorrectRate
      });

    } else {
      Tabs({ index: this.currentTabIndex }) {
        TabContent() {
          StudyHomeTab({
            currentTabIndex: $currentTabIndex,
            selectedBookId: $selectedBookId,
            practiceMode: $practiceMode,
            showPracticePage: $showPracticePage,
            bookList: $bookList,
            totalLearnedWords: $totalLearnedWords,
            streakDays: $streakDays,
            accuracyRate: $accuracyRate,
            reviewDue: $reviewDue,
            todayFinishedWords: $todayFinishedWords,
            todayCorrectRate: $todayCorrectRate
          });

        }.tabBar(this.tabBarBuilder(0, '背词'))

        TabContent() {
          BookTab({
            currentTabIndex: $currentTabIndex,
            selectedBookId: $selectedBookId,
            bookList: $bookList
          });

        }.tabBar(this.tabBarBuilder(1, '词书'))

        TabContent() {
          MineTab({
            selectedBookId: $selectedBookId,
            bookList: $bookList,
            notebookCount: $notebookCount,
            wrongCount: $wrongCount,
            studyRecordCount: $studyRecordCount
          });

        }.tabBar(this.tabBarBuilder(2, '我的'))
      }
      .barPosition(BarPosition.End)
      .backgroundColor('#FFF8F3')
      .onChange((index: number) => {
        this.currentTabIndex = index;
        if (index === 2) {
          this.loadMineCounts();
        }
      })

      .onAppear(() => {
        this.loadProfileAndStats();
        this.loadBookProgress();
        this.loadMineCounts();
      })


    }
  }

  @Builder
  tabBarBuilder(index: number, title: string) {
    Column({ space: 4 }) {
      Text(this.currentTabIndex === index ? '●' : '○')
        .fontSize(8)
        .fontColor(this.currentTabIndex === index ? '#F97316' : '#C9B8A6')
      Text(title)
        .fontSize(12)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Bold : FontWeight.Medium)
        .fontColor(this.currentTabIndex === index ? '#2F2A24' : '#8A8179')
    }
    .padding({ top: 8, bottom: 8 })
    .width('100%')
  }
}

@Component
struct StudyHomeTab {
  @Link currentTabIndex: number;
  @Link selectedBookId: number;
  @Link practiceMode: string;
  @Link showPracticePage: boolean;
  @Link bookList: BookCard[];
  @Link totalLearnedWords: number;
  @Link streakDays: number;
  @Link accuracyRate: number;
  @Link reviewDue: number;
  @Link todayFinishedWords: number;
  @Link todayCorrectRate: number;
  @State signedIn: boolean = false;

  currentBook(): BookCard {
    for (let i = 0; i < this.bookList.length; i++) {
      if (this.bookList[i].id === this.selectedBookId) {
        return this.bookList[i];
      }
    }
    return this.bookList.length > 0 ? this.bookList[0] : emptyBookCard(this.selectedBookId);
  }

  remainingLearnWords(): number {
    const book: BookCard = this.currentBook();
    if (book.totalWords <= 0) {
      const fallbackRemaining: number = 300 - this.totalLearnedWords;
      return fallbackRemaining > 0 ? fallbackRemaining : 0;
    }

    const remaining: number = book.totalWords - book.learnedWords;
    return remaining > 0 ? remaining : 0;
  }

  currentReviewWords(): number {
    const book: BookCard = this.currentBook();
    if (book.totalWords <= 0) {
      return this.reviewDue > 0 ? this.reviewDue : 0;
    }
    return book.todayReview > 0 ? book.todayReview : 0;
  }

  dateText(): string {
    const date: Date = new Date();
    const weekdays: string[] = ['Sun.', 'Mon.', 'Tue.', 'Wed.', 'Thu.', 'Fri.', 'Sat.'];
    const month: string = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1).toString();
    const day: string = date.getDate() < 10 ? '0' + date.getDate() : date.getDate().toString();
    return month + '/' + day + ' ' + weekdays[date.getDay()];
  }

  openBooks() {
    this.currentTabIndex = 1;
  }

  openPractice(mode: string) {
    this.practiceMode = mode;
    this.showPracticePage = true;
  }

  loadSignStatus() {
    ApiService.get('/api/sign/status?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as BooleanResultResponse;
          if (response.code === 200 && response.data !== null) {
            this.signedIn = response.data;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('load sign status parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('load sign status failed: ' + error.message);
      });
  }

  signToday() {
    if (this.signedIn) {
      showToast(this.getUIContext(), '今天已经签到');
      return;
    }

    const requestBody: EmptyRequestBody = {};
    ApiService.post('/api/sign?userId=' + currentUser.id, requestBody)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as SimpleResultResponse;
          if (response.code !== 200) {
            showToast(this.getUIContext(), response.message);
            return;
          }

          this.signedIn = true;
          showToast(this.getUIContext(), '签到成功');
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('sign parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '签到失败');
        console.error('sign failed: ' + error.message);
      });
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Stack() {
          Column()
            .width('100%')
            .height(508)
            .backgroundColor('#F6EFE6')
            .borderRadius(38)

          Column()
            .width(220)
            .height(220)
            .borderRadius(110)
            .backgroundColor('#FFDCC4')
            .opacity(0.85)
            .align(Alignment.TopStart)
            .offset({ x: -70, y: -60 })

          Column()
            .width(240)
            .height(240)
            .borderRadius(120)
            .backgroundColor('#DFF3EC')
            .opacity(0.82)
            .align(Alignment.BottomEnd)
            .offset({ x: 80, y: 40 })

          Column()
            .width(170)
            .height(170)
            .borderRadius(85)
            .backgroundColor('#E7DEFF')
            .opacity(0.7)
            .align(Alignment.Center)
            .offset({ x: 60, y: -20 })

          Column({ space: 14 }) {
            Column()
              .height(10)

            Column({ space: 8 }) {
              if (this.signedIn) {
                Text('✓')
                  .fontSize(34)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#F97316')
              } else {
                this.calendarIcon()
              }
              Text(this.dateText())
                .fontSize(17)
                .fontColor('#55504B')
            }
            .width(182)
            .padding({ top: 28, bottom: 28 })
            .backgroundColor('#D9FFFFFF')
            .borderRadius(34)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              this.signToday();
            })

            Blank()

            Row({ space: 14 }) {
              this.focusCard('Learn', this.remainingLearnWords().toString(), 'learn')
              this.focusCard('Review', this.currentReviewWords().toString(), 'review')
            }
            .width('100%')

            Button('打开词书列表')
              .width('100%')
              .height(48)
              .backgroundColor('#EFFFFFFF')
              .fontColor('#1F1F1F')
              .borderRadius(24)
              .onClick(() => {
                this.openBooks();
              })
          }
          .width('100%')
          .height('100%')
          .padding({ left: 18, right: 18, top: 14, bottom: 18 })
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height(508)

        Column({ space: 12 }) {
          Text('今日学习概览')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2F2A24')
            .width('100%')

          Row({ space: 12 }) {
            this.metricCard('今日已学', this.todayFinishedWords.toString())
            this.metricCard('今日正确率', this.todayCorrectRate.toString() + '%')
            this.metricCard('累计已学', this.totalLearnedWords.toString())
          }
          .width('100%')
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 20 })
    }
    .backgroundColor('#FFF8F3')
    .onAppear(() => {
      this.loadSignStatus();
    })
  }

  @Builder
  calendarIcon() {
    Stack() {
      Column() {
        Row()
          .height(8)

        Row({ space: 6 }) {
          Column()
            .width(9)
            .height(2)
            .backgroundColor('#1F1F1F')
            .borderRadius(1)
          Column()
            .width(9)
            .height(2)
            .backgroundColor('#1F1F1F')
            .borderRadius(1)
        }
        .height(8)
        .justifyContent(FlexAlign.Center)

        Column()
          .width(14)
          .height(2)
          .backgroundColor('#1F1F1F')
          .borderRadius(1)
      }
      .width(38)
      .height(36)
      .padding({ top: 7, bottom: 7 })
      .border({ width: 3, color: '#1F1F1F' })
      .borderRadius(6)
      .alignItems(HorizontalAlign.Center)

      Row({ space: 14 }) {
        Column()
          .width(3)
          .height(9)
          .backgroundColor('#1F1F1F')
          .borderRadius(2)
        Column()
          .width(3)
          .height(9)
          .backgroundColor('#1F1F1F')
          .borderRadius(2)
      }
      .align(Alignment.Top)
      .offset({ y: -4 })
    }
    .width(46)
    .height(42)
  }

  @Builder
  focusCard(title: string, value: string, mode: string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F1F1F')
      Text(value)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#F2994A')
    }
    .layoutWeight(1)
    .height(118)
    .padding(18)
    .backgroundColor('#CCFFFFFF')
    .borderRadius(28)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.openPractice(mode);
    })
  }

  @Builder
  metricCard(title: string, value: string) {
    Column({ space: 6 }) {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24')
      Text(title)
        .fontSize(12)
        .fontColor('#7C6754')
    }
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor('#FFFDF9')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
struct StudyPracticePage {
  @Link selectedBookId: number;
  @Link practiceMode: string;
  @Link showPracticePage: boolean;
  @Link bookList: BookCard[];
  @Link totalLearnedWords: number;
  @Link streakDays: number;
  @Link accuracyRate: number;
  @Link reviewDue: number;
  @Link todayFinishedWords: number;
  @Link todayCorrectRate: number;

  @State currentIndex: number = 0;
  @State selectedOption: string = '';
  @State wordBank: LearningWord[] = [];
  @State currentQuestion: LearningWord | null = null;
  @State loading: boolean = false;

  currentBook(): BookCard {
    for (let i = 0; i < this.bookList.length; i++) {
      if (this.bookList[i].id === this.selectedBookId) {
        return this.bookList[i];
      }
    }
    return this.bookList.length > 0 ? this.bookList[0] : emptyBookCard(this.selectedBookId);
  }

  refreshStatsAfterSubmit() {
    ApiService.get('/api/stats/overview?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as StatsResponse;
          if (response.code === 200 && response.data !== null) {
            userProfile.totalLearnedWords = response.data.totalLearnedWords;
            userProfile.streakDays = response.data.streakDays;
            userProfile.accuracyRate = response.data.accuracyRate;
            userProfile.reviewDue = response.data.reviewDue;
            this.totalLearnedWords = response.data.totalLearnedWords;
            this.streakDays = response.data.streakDays;
            this.accuracyRate = response.data.accuracyRate;
            this.reviewDue = response.data.reviewDue;
            this.todayFinishedWords = response.data.todayFinishedWords;
            this.todayCorrectRate = response.data.todayCorrectRate;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('refresh stats parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('refresh stats failed: ' + error.message);
      });
  }

  refreshBookProgressAfterSubmit() {
    ApiService.get('/api/books/progress?userId=' + currentUser.id)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as BookProgressResponse;
          if (response.code !== 200 || response.data === null) {
            return;
          }

          this.bookList = response.data.map((item: BookProgressItem): BookCard => {
            return {
              id: item.id,
              title: item.title,
              levelTag: item.levelTag,
              description: item.description,
              totalWords: item.totalWords,
              learnedWords: item.learnedWords,
              todayNew: item.todayNew,
              todayReview: item.todayReview,
              streakDays: this.streakDays,
              progress: item.progress,
              accentColor: item.accentColor,
              softColor: item.softColor
            };
          });
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('refresh book progress parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('refresh book progress failed: ' + error.message);
      });
  }

  currentQueue(): LearningWord[] {
    return this.wordBank;
  }

  buildPracticeGroup(allWords: LearningWord[]): LearningWord[] {
    const groupSize: number = 10;
    if (allWords.length <= groupSize) {
      return allWords;
    }

    const startIndex: number = this.currentBook().learnedWords % allWords.length;
    const group: LearningWord[] = [];
    for (let i = 0; i < groupSize; i++) {
      const index: number = (startIndex + i) % allWords.length;
      group.push(allWords[index]);
    }
    return group;
  }

  emptyWord(): LearningWord {
    return {
      id: 0,
      bookId: this.selectedBookId,
      bookTitle: this.currentBook().title,
      word: '',
      phonetic: '',
      meaning: '暂无可学习单词',
      memoryTip: '请先确认后端 words 表里有当前词书的单词数据。',
      example: '',
      translation: '',
      answer: '',
      options: [],
      difficulty: ''
    };
  }

  currentWord(): LearningWord {
    if (this.currentQuestion !== null) {
      return this.currentQuestion;
    }

    const queue: LearningWord[] = this.currentQueue();
    if (queue.length === 0) {
      return this.emptyWord();
    }

    const safeIndex: number = this.currentIndex >= queue.length ? Math.max(queue.length - 1, 0) : this.currentIndex;
    return queue[safeIndex];
  }

  shuffleOptions(options: string[]): string[] {
    const copied: string[] = [];
    for (let i = 0; i < options.length; i++) {
      copied.push(options[i]);
    }

    for (let i = copied.length - 1; i > 0; i--) {
      const randomIndex: number = Math.floor(Math.random() * (i + 1));
      const temp: string = copied[i];
      copied[i] = copied[randomIndex];
      copied[randomIndex] = temp;
    }

    return copied;
  }

  buildOptions(correctAnswer: string, sourceWords: LearningWord[]): string[] {
    const collected: string[] = [correctAnswer];

    for (let i = 0; i < sourceWords.length; i++) {
      const option: string = sourceWords[i].meaning;
      if (option !== correctAnswer && collected.indexOf(option) < 0) {
        collected.push(option);
      }
      if (collected.length >= 4) {
        break;
      }
    }

    return this.shuffleOptions(collected);
  }

  attachOptions(item: LearningWord, sourceWords: LearningWord[]): LearningWord {
    return {
      id: item.id,
      bookId: item.bookId,
      bookTitle: item.bookTitle,
      word: item.word,
      phonetic: item.phonetic,
      meaning: item.meaning,
      memoryTip: item.memoryTip,
      example: item.example,
      translation: item.translation,
      answer: item.answer,
      options: this.buildOptions(item.answer, sourceWords),
      difficulty: item.difficulty
    };
  }

  mapWordItem(item: WordApiItem): LearningWord {
    return {
      id: item.id,
      bookId: item.bookId,
      bookTitle: this.currentBook().title,
      word: item.word,
      phonetic: item.phonetic,
      meaning: item.meaning,
      memoryTip: item.memoryTip,
      example: item.exampleText,
      translation: item.translationText,
      answer: item.answer,
      options: [],
      difficulty: item.difficulty
    };
  }

  loadWordBank() {
    this.loading = true;

    ApiService.get('/api/words?bookId=' + this.selectedBookId)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as WordListResponse;

          if (response.code !== 200 || response.data === null) {
            this.loading = false;
            showToast(this.getUIContext(), response.message);
            return;
          }

          const mapped: LearningWord[] = response.data.map((item: WordApiItem): LearningWord => this.mapWordItem(item));
          const currentGroup: LearningWord[] = this.buildPracticeGroup(mapped);
          const wordsWithOptions: LearningWord[] = currentGroup.map((item: LearningWord): LearningWord => this.attachOptions(item, mapped));

          this.wordBank = wordsWithOptions;
          this.currentIndex = 0;
          this.currentQuestion = wordsWithOptions.length > 0 ? wordsWithOptions[0] : null;
          this.selectedOption = '';
          this.loading = false;
        } catch (error) {
          const err = error as BusinessError<number>;
          this.loading = false;
          showToast(this.getUIContext(), '单词列表解析失败');
          console.error('load word bank parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        this.loading = false;
        showToast(this.getUIContext(), '单词列表加载失败');
        console.error('load word bank failed: ' + error.message);
      });
  }

  loadNextWord() {
    const queue: LearningWord[] = this.currentQueue();
    if (queue.length === 0) {
      this.currentQuestion = null;
      this.selectedOption = '';
      return;
    }

    const safeIndex: number = this.currentIndex >= queue.length ? queue.length - 1 : this.currentIndex;
    this.currentQuestion = queue[safeIndex];
    this.selectedOption = '';
  }

  tomorrowText(): string {
    const date: Date = new Date();
    date.setDate(date.getDate() + 1);

    const year: string = date.getFullYear().toString();
    const month: string = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1).toString();
    const day: string = date.getDate() < 10 ? '0' + date.getDate() : date.getDate().toString();
    return year + '-' + month + '-' + day;
  }

  addToNotebook() {
    const word: LearningWord = this.currentWord();
    if (word.id <= 0) {
      showToast(this.getUIContext(), '暂无可加入的单词');
      return;
    }

    const requestBody: NotebookWordAddRequestBody = {
      userId: currentUser.id,
      wordId: word.id,
      word: word.word,
      meaning: word.meaning,
      bookTitle: this.currentBook().title,
      masteryLabel: '待复习',
      nextReview: this.tomorrowText(),
      noteText: word.memoryTip
    };

    ApiService.post('/api/notebook-words', requestBody)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as SimpleResultResponse;
          if (response.code !== 200) {
            showToast(this.getUIContext(), response.message);
            return;
          }

          showToast(this.getUIContext(), response.data === 'notebook word already exists' ? '生词本已存在' : '已加入生词本');
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('add notebook parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '加入生词本失败');
        console.error('add notebook failed: ' + error.message);
      });
  }

  modeTitle(): string {
    return this.practiceMode === 'review' ? '复习模式' : '背词练习';
  }

  progressText(): string {
    const total: number = this.currentQueue().length;
    const current: number = total > 0 ? this.currentIndex + 1 : 0;
    return current.toString() + '/' + total.toString();
  }


  optionBackground(option: string): string {
    if (this.selectedOption.length === 0) {
      return '#FFFDF9';
    }
    if (option === this.currentWord().answer) {
      return '#E8F7EE';
    }
    if (option === this.selectedOption) {
      return '#FDEDED';
    }
    return '#FFFDF9';
  }

  optionBorder(option: string): string {
    if (this.selectedOption.length === 0) {
      return '#F1E4D6';
    }
    if (option === this.currentWord().answer) {
      return '#2E9B62';
    }
    if (option === this.selectedOption) {
      return '#E45B5B';
    }
    return '#F1E4D6';
  }

  chooseOption(option: string) {
    this.selectedOption = option;
  }

  submitAndNext() {
    if (this.currentWord().id <= 0) {
      showToast(this.getUIContext(), '暂无可提交的单词');
      return;
    }

    if (this.selectedOption.length === 0) {
      showToast(this.getUIContext(), '请先选择答案');
      return;
    }

    const word: LearningWord = this.currentWord();
    const isCorrect: boolean = this.selectedOption === word.answer;

    const requestBody: StudySubmitRequestBody = {
      userId: currentUser.id,
      bookTitle: this.currentBook().title,
      wordId: word.id,
      word: word.word,
      meaning: word.meaning,
      isCorrect: isCorrect,
      selectedAnswer: this.selectedOption,
      correctAnswer: word.answer,
      sentence: word.example,
      reason: isCorrect ? '' : '选择了错误释义'
    };

    ApiService.post('/api/study/submit', requestBody)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as SimpleResultResponse;

          if (response.code !== 200) {
            showToast(this.getUIContext(), response.message);
            return;
          }

          this.refreshStatsAfterSubmit();
          this.refreshBookProgressAfterSubmit();

          if (this.currentIndex < this.currentQueue().length - 1) {
            this.currentIndex += 1;
            this.loadNextWord();
            return;
          }

          showToast(this.getUIContext(), '本轮练习完成');
          this.exitPractice();
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('submit study parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        showToast(this.getUIContext(), '学习提交失败');
        console.error('submit study failed: ' + error.message);
      });
  }


  exitPractice() {
    this.currentIndex = 0;
    this.selectedOption = '';
    this.currentQuestion = null;
    this.wordBank = [];
    this.loading = false;
    this.showPracticePage = false;
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Row() {
          Text('< 返回')
            .fontSize(15)
            .fontColor('#F97316')
            .onClick(() => {
              this.exitPractice();
            })

          Blank()

          Text(this.modeTitle())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2F2A24')

          Blank()

          Text(this.progressText())
            .fontSize(13)
            .fontColor('#8A8179')
        }
        .width('100%')

        Column({ space: 8 }) {
          Text(this.currentWord().word)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F1F1F')
            .width('100%')

          Text(this.currentWord().phonetic)
            .fontSize(14)
            .fontColor('#8A8179')
            .width('100%')

          Divider()
            .color('#F2E5D8')

          Text(this.currentWord().example)
            .fontSize(12)
            .lineHeight(18)
            .fontColor('#3E3832')
            .width('100%')

          if (this.selectedOption.length === 0) {
            Text('先根据单词和例句选择正确释义，提交后再显示答案解析。')
              .fontSize(12)
              .lineHeight(17)
              .fontColor('#8A8179')
              .width('100%')
          } else {
            Text('正确释义：' + this.currentWord().answer)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#2F2A24')
              .width('100%')

            Text(this.currentWord().memoryTip)
              .fontSize(12)
              .lineHeight(17)
              .fontColor('#6B6258')
              .width('100%')

            Text(this.currentWord().translation)
              .fontSize(12)
              .lineHeight(17)
              .fontColor('#7C6754')
              .width('100%')
          }
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#FFFDF9')
        .borderRadius(28)
        .alignItems(HorizontalAlign.Start)

        Column({ space: 6 }) {
          Text('选择正确释义')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2F2A24')
            .width('100%')

          ForEach(this.currentWord().options, (option: string) => {
            this.optionRow(option);
          }, (option: string) => option)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFF8F1')
        .borderRadius(28)

        Row({ space: 10 }) {
          this.actionButton('加入生词本', '#FFF5EA', this.currentBook().accentColor, () => {
            this.addToNotebook();
          })
          this.actionButton('退出练习', '#FFF5EA', this.currentBook().accentColor, () => {
            this.exitPractice();
          })
          this.actionButton('提交下一题', this.currentBook().accentColor, '#FFFFFF', () => {
            this.submitAndNext();
          })
        }

        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 16 })
    }
    .backgroundColor('#FFF8F3')
    .onAppear(() => {
      this.currentIndex = 0;
      this.selectedOption = '';
      this.currentQuestion = null;
      this.wordBank = [];
      this.loadWordBank();
    })

  }

  @Builder
  optionRow(option: string) {
    Row({ space: 12 }) {
      Text(option)
        .fontSize(13)
        .lineHeight(20)
        .fontColor('#2F2A24')
        .layoutWeight(1)

      if (this.selectedOption.length > 0 && option === this.currentWord().answer) {
        Text('正确')
          .fontSize(12)
          .fontColor('#2E9B62')
      } else if (option === this.selectedOption && option !== this.currentWord().answer) {
        Text('再记')
          .fontSize(12)
          .fontColor('#E45B5B')
      }
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(this.optionBackground(option))
    .borderRadius(18)
    .border({
      width: 1,
      color: this.optionBorder(option)
    })
    .onClick(() => {
      this.chooseOption(option);
    })
  }

  @Builder
  actionButton(label: string, backgroundColor: string, fontColor: string, handler: () => void) {
    Button(label)
      .layoutWeight(1)
      .height(40)
      .backgroundColor(backgroundColor)
      .fontColor(fontColor)
      .borderRadius(22)
      .onClick(() => {
        handler();
      })
  }

}

@Component
struct BookTab {
  @Link currentTabIndex: number;
  @Link selectedBookId: number;
  @Link bookList: BookCard[];

  isCurrentBook(bookId: number): boolean {
    return this.selectedBookId === bookId;
  }

  switchBook(bookId: number) {
    this.selectedBookId = bookId;
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Column({ space: 12 }) {
          Swiper() {
            this.motivationSlide('别等状态来了再开始，开始之后状态才会来。', '今天也向前一点点。', '#7A4E2D')
            this.motivationSlide('你背下的每一个词，都会在未来替你说话。', '把重复变成底气。', '#0F766E')
            this.motivationSlide('真正拉开差距的，不是天赋，是稳定重复。', '继续保持今天的节奏。', '#6D28D9')
          }
          .autoPlay(true)
          .interval(3200)
          .loop(true)
          .indicator(Indicator.dot()
            .color('#E8D2BF')
            .selectedColor('#F97316'))
          .height(172)
        }
        .width('100%')

        Column({ space: 14 }) {
          if (this.bookList.length === 0) {
            this.emptyBooks()
          } else {
            ForEach(this.bookList, (item: BookCard) => {
              this.bookCard(item);
            }, (item: BookCard) => item.id.toString())
          }
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 24 })
      .alignItems(HorizontalAlign.Start)
    }
    .backgroundColor('#FFF8F3')
  }

  @Builder
  emptyBooks() {
    Column({ space: 10 }) {
      Text('词书加载中')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24')

      Text('如果一直没有词书，请确认后端服务已启动，并且 /api/books/progress 能返回数据。')
        .fontSize(13)
        .lineHeight(20)
        .fontColor('#7C6754')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding(24)
    .backgroundColor('#FFFDF9')
    .borderRadius(24)
  }

  @Builder
  motivationSlide(title: string, subtitle: string, tintColor: string) {
    Stack() {
      Image($r('app.media.1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(tintColor + '33')

      Column({ space: 8 }) {
        Text(title)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .lineHeight(30)
          .width('100%')

        Text(subtitle)
          .fontSize(14)
          .fontColor('#FFF7ED')
          .width('100%')
      }
      .width('100%')
      .padding(18)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.End)
      .backgroundColor('#00000022')
    }
    .width('100%')
    .height('100%')
    .borderRadius(28)
    .clip(true)
  }

  @Builder
  smallMetric(label: string, value: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24')
      Text(label)
        .fontSize(12)
        .fontColor('#7C6754')
    }
    .layoutWeight(1)
    .padding({ left: 14, right: 14, top: 12, bottom: 12 })
    .backgroundColor('#FFFDF9')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  bookTag(item: BookCard) {
    Text(item.levelTag)
      .fontSize(12)
      .fontColor(item.accentColor)
      .padding({ left: 10, right: 10, top: 6, bottom: 6 })
      .backgroundColor('#FFFFFFFF')
      .borderRadius(14)
  }

  @Builder
  bookCard(item: BookCard) {
    Column({ space: 16 }) {
      Column({ space: 10 }) {
        Text(item.title)
          .fontSize(19)
          .fontWeight(FontWeight.Bold)
          .fontColor('#2F2A24')
          .width('100%')

        Row() {
          this.bookTag(item)
          Blank()
        }
        .width('100%')

        Text(item.description)
          .fontSize(13)
          .lineHeight(21)
          .fontColor('#6B6258')
          .width('100%')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      Row({ space: 10 }) {
        this.smallMetric('总词数', item.totalWords.toString())
        this.smallMetric('已学', item.learnedWords.toString())
        this.smallMetric('待复习', item.todayReview.toString())
      }
      .width('100%')

      Progress({ value: item.progress, total: 100, type: ProgressType.Linear })
        .color(item.accentColor)
        .backgroundColor('#FFFFFF')
        .height(8)

      Button(this.isCurrentBook(item.id) ? '当前词书' : '设为当前')
        .width('100%')
        .height(40)
        .backgroundColor(this.isCurrentBook(item.id) ? '#FFF8F1' : item.accentColor)
        .fontColor(this.isCurrentBook(item.id) ? item.accentColor : Color.White)
        .borderRadius(20)
        .onClick(() => {
          this.switchBook(item.id);
        })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(item.softColor)
    .borderRadius(24)
  }
}

@Component
struct MineTab {
  @Link selectedBookId: number;
  @Link bookList: BookCard[];
  @Link notebookCount: number;
  @Link wrongCount: number;
  @Link studyRecordCount: number;

  currentBook(): BookCard {
    for (let i = 0; i < this.bookList.length; i++) {
      if (this.bookList[i].id === this.selectedBookId) {
        return this.bookList[i];
      }
    }
    return this.bookList.length > 0 ? this.bookList[0] : emptyBookCard(this.selectedBookId);
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Column({ space: 16 }) {
          Row({ space: 14 }) {
            Column()
              .width(82)
              .height(82)
              .borderRadius(41)
              .backgroundColor('#F4A261')

            Column() {
              Text(userProfile.nickname)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2F2A24')
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')

        }
        .width('100%')
        .padding(20)
        .backgroundColor('#FFE7CF')
        .borderRadius(28)

        Column({ space: 0 }) {
          this.menuRow('我的生词本', this.notebookCount.toString() + ' 个词', 'pages/CollectionPage')
          Divider().color('#F3E4D5')
          this.menuRow('错题本', this.wrongCount.toString() + ' 条待复盘', 'pages/WrongBookPage')
          Divider().color('#F3E4D5')
          this.menuRow('学习记录', this.studyRecordCount.toString() + ' 天记录', 'pages/StudyRecordPage')
          Divider().color('#F3E4D5')
          this.menuRow('个人资料', this.currentBook().levelTag + ' 默认词书', 'pages/ProfilePage')
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .backgroundColor('#FFFDF9')
        .borderRadius(24)

        Button('退出登录')
          .width('100%')
          .height(46)
          .backgroundColor('#FFF1E6')
          .fontColor('#F97316')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .borderRadius(20)
          .onClick(() => {
            resetCurrentUser();
            pushUrl(this.getUIContext(), 'pages/LoginPage');
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 20, bottom: 24 })
    }
    .backgroundColor('#FFF8F3')
  }

  @Builder
  menuRow(title: string, value: string, url: string) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#2F2A24')

      Blank()

      Row({ space: 8 }) {
        Text(value)
          .fontSize(13)
          .fontColor('#7C6754')
        Text('>')
          .fontSize(20)
          .fontColor('#F97316')
      }
    }
    .width('100%')
    .padding({ top: 18, bottom: 18 })
    .onClick(() => {
      pushUrl(this.getUIContext(), url);
    })
  }
}

@Preview
@Component
struct MainPagePreview {
  build() {
    MainPage();
  }
}

@Preview
@Component
struct StudyHomeTabPreview {
  @State previewTabIndex: number = 0;
  @State previewBookId: number = userProfile.selectedBookId;
  @State previewPracticeMode: string = 'learn';
  @State previewShowPracticePage: boolean = false;
  @State previewBookList: BookCard[] = [];
  @State previewTotalLearnedWords: number = 0;
  @State previewStreakDays: number = 0;
  @State previewAccuracyRate: number = 0;
  @State previewReviewDue: number = 0;
  @State previewTodayFinishedWords: number = 0;
  @State previewTodayCorrectRate: number = 0;

  build() {
    StudyHomeTab({
      currentTabIndex: $previewTabIndex,
      selectedBookId: $previewBookId,
      practiceMode: $previewPracticeMode,
      showPracticePage: $previewShowPracticePage,
      bookList: $previewBookList,
      totalLearnedWords: $previewTotalLearnedWords,
      streakDays: $previewStreakDays,
      accuracyRate: $previewAccuracyRate,
      reviewDue: $previewReviewDue,
      todayFinishedWords: $previewTodayFinishedWords,
      todayCorrectRate: $previewTodayCorrectRate
    });

  }
}

@Preview
@Component
struct StudyPracticePagePreview {
  @State previewBookId: number = userProfile.selectedBookId;
  @State previewPracticeMode: string = 'learn';
  @State previewShowPracticePage: boolean = true;
  @State previewBookList: BookCard[] = [];
  @State previewTotalLearnedWords: number = 0;
  @State previewStreakDays: number = 0;
  @State previewAccuracyRate: number = 0;
  @State previewReviewDue: number = 0;
  @State previewTodayFinishedWords: number = 0;
  @State previewTodayCorrectRate: number = 0;

  build() {
    StudyPracticePage({
      selectedBookId: $previewBookId,
      practiceMode: $previewPracticeMode,
      showPracticePage: $previewShowPracticePage,
      bookList: $previewBookList,
      totalLearnedWords: $previewTotalLearnedWords,
      streakDays: $previewStreakDays,
      accuracyRate: $previewAccuracyRate,
      reviewDue: $previewReviewDue,
      todayFinishedWords: $previewTodayFinishedWords,
      todayCorrectRate: $previewTodayCorrectRate
    });

  }
}

@Preview
@Component
struct BookTabPreview {
  @State previewTabIndex: number = 1;
  @State previewBookId: number = userProfile.selectedBookId;
  @State previewBookList: BookCard[] = [];

  build() {
    BookTab({
      currentTabIndex: $previewTabIndex,
      selectedBookId: $previewBookId,
      bookList: $previewBookList
    });

  }
}

@Preview
@Component
struct MineTabPreview {
  @State previewBookId: number = userProfile.selectedBookId;
  @State previewBookList: BookCard[] = [];
  @State previewNotebookCount: number = 0;
  @State previewWrongCount: number = 0;
  @State previewStudyRecordCount: number = 0;

  build() {
    MineTab({
      selectedBookId: $previewBookId,
      bookList: $previewBookList,
      notebookCount: $previewNotebookCount,
      wrongCount: $previewWrongCount,
      studyRecordCount: $previewStudyRecordCount
    });

  }
}

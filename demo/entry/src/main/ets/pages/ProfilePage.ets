import { BusinessError } from '@kit.BasicServicesKit';
import { ApiService } from '../api/ApiService';
import { UserProfile, userProfile } from '../data/AppState';
import { currentUser } from '../data/CurrentUser';
import { showToast, routerBack } from '../utils/UiFeedback';

interface ProfileResponseData {
  id: number;
  account: string;
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

interface UpdateProfileRequestBody {
  userId: number;
  nickname: string;
  dailyTarget: number;
  signature: string;
  selectedBookId: number;
}

interface BookOption {
  id: number;
  title: string;
}

interface BookListResponse {
  code: number;
  message: string;
  data: BookOption[] | null;
}

@Entry
@Component
struct ProfilePage {
  @State nickname: string = userProfile.nickname;
  @State goal: string = userProfile.dailyTarget.toString();
  @State signature: string = userProfile.signature;
  @State selectedBookId: number = userProfile.selectedBookId;
  @State errorMessage: string = '';
  @State userId: number = currentUser.id;
  @State bookList: BookOption[] = [];


  applyProfile(profile: UserProfile) {
    this.nickname = profile.nickname;
    this.goal = profile.dailyTarget.toString();
    this.signature = profile.signature;
    this.selectedBookId = profile.selectedBookId;
  }

  loadProfile() {
    ApiService.get('/api/user/profile?userId=' + this.userId)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as ProfileResponse;

          if (response.code !== 200 || response.data === null) {
            this.errorMessage = response.message;
            return;
          }

          userProfile.nickname = response.data.nickname;
          userProfile.dailyTarget = response.data.dailyTarget;
          userProfile.signature = response.data.signature;
          userProfile.selectedBookId = response.data.selectedBookId;
          userProfile.totalLearnedWords = response.data.totalLearnedWords;
          userProfile.streakDays = response.data.streakDays;
          userProfile.accuracyRate = response.data.accuracyRate;
          userProfile.reviewDue = response.data.reviewDue;

          this.applyProfile(userProfile);
          this.errorMessage = '';
        } catch (error) {
          const err = error as BusinessError<number>;
          this.errorMessage = '资料解析失败';
          console.error('load profile parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        this.errorMessage = '资料加载失败';
        console.error('load profile failed: ' + error.message);
      });
  }

  loadBooks() {
    ApiService.get('/api/books')
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as BookListResponse;
          if (response.code === 200 && response.data !== null) {
            this.bookList = response.data;
          }
        } catch (error) {
          const err = error as BusinessError<number>;
          console.error('load profile books parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        console.error('load profile books failed: ' + error.message);
      });
  }

  displayAvatarText(): string {
    if (this.nickname.length === 0) {
      return '晨';
    }
    return this.nickname.substring(0, 1);
  }

  selectedBookTitle(): string {
    for (let i = 0; i < this.bookList.length; i++) {
      if (this.bookList[i].id === this.selectedBookId) {
        return this.bookList[i].title;
      }
    }
    return this.selectedBookId.toString();
  }

  parsedGoal(): number {
    const parsed: number = parseInt(this.goal, 10);
    if (isNaN(parsed)) {
      return 0;
    }
    return parsed;
  }

  saveProfile() {
    if (this.nickname.trim().length === 0) {
      this.errorMessage = '昵称不能为空';
      return;
    }

    const dailyTarget: number = this.parsedGoal();
    if (dailyTarget <= 0) {
      this.errorMessage = '每日目标必须大于 0';
      return;
    }

    const requestBody: UpdateProfileRequestBody = {
      userId: this.userId,
      nickname: this.nickname.trim(),
      dailyTarget: dailyTarget,
      signature: this.signature.trim(),
      selectedBookId: this.selectedBookId
    };

    ApiService.put('/api/user/profile', requestBody)
      .then((result: string) => {
        try {
          const response = JSON.parse(result) as ProfileResponse;

          if (response.code !== 200 || response.data === null) {
            this.errorMessage = response.message;
            return;
          }

          userProfile.nickname = response.data.nickname;
          userProfile.dailyTarget = response.data.dailyTarget;
          userProfile.signature = response.data.signature;
          userProfile.selectedBookId = response.data.selectedBookId;
          userProfile.totalLearnedWords = response.data.totalLearnedWords;
          userProfile.streakDays = response.data.streakDays;
          userProfile.accuracyRate = response.data.accuracyRate;
          userProfile.reviewDue = response.data.reviewDue;

          this.applyProfile(userProfile);
          this.errorMessage = '';
          showToast(this.getUIContext(), '保存成功');
          routerBack(this.getUIContext());
        } catch (error) {
          const err = error as BusinessError<number>;
          this.errorMessage = '保存响应解析失败';
          console.error('save profile parse failed: ' + err.message);
        }
      })
      .catch((error: BusinessError<number>) => {
        this.errorMessage = '保存失败，请检查网络或后端服务';
        console.error('save profile failed: ' + error.message);
      });
  }


  build() {
    Column({ space: 16 }) {
      this.pageHeader('个人资料');

      Scroll() {
        Column({ space: 16 }) {
          Column({ space: 10 }) {
            Column() {
              Text(this.displayAvatarText())
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor('#F97316');
            }
            .width(80)
            .height(80)
            .borderRadius(40)
            .backgroundColor('#FFE7CF');

            Text(this.nickname.length > 0 ? this.nickname : '晨读计划同学')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2F2A24');

            Text('默认词书：' + this.selectedBookTitle())
              .fontSize(13)
              .fontColor('#7C6754');
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#FFFDF9')
          .borderRadius(24);

          if (this.errorMessage.length > 0) {
            Column({ space: 8 }) {
              Text(this.errorMessage)
                .fontSize(13)
                .fontColor('#E45B5B');
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFF7ED')
            .borderRadius(20)
            .alignItems(HorizontalAlign.Start);
          }

          Column({ space: 12 }) {
            Text('昵称')
              .width('100%')
              .fontSize(14)
              .fontColor('#7C6754');
            TextInput({ text: this.nickname, placeholder: '请输入昵称' })
              .height(50)
              .backgroundColor('#FFF7ED')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.nickname = value;
              });

            Text('每日学习目标')
              .width('100%')
              .fontSize(14)
              .fontColor('#7C6754');
            TextInput({ text: this.goal, placeholder: '请输入每日学习词数' })
              .height(50)
              .backgroundColor('#FFF7ED')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.goal = value;
              });

            Text('学习签名')
              .width('100%')
              .fontSize(14)
              .fontColor('#7C6754');
            TextInput({ text: this.signature, placeholder: '写一句鼓励自己的话' })
              .height(50)
              .backgroundColor('#FFF7ED')
              .borderRadius(16)
              .padding({ left: 14, right: 14 })
              .onChange((value: string) => {
                this.signature = value;
              });
          }
          .width('100%')
          .padding(18)
          .backgroundColor('#FFFDF9')
          .borderRadius(24);

          Button('保存并返回')
            .width('100%')
            .height(46)
            .backgroundColor('#F97316')
            .fontColor(Color.White)
            .borderRadius(18)
            .onClick(() => {
              this.saveProfile();
            });
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
      this.loadProfile();
      this.loadBooks();
    });

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
struct ProfilePagePreview {
  build() {
    ProfilePage();
  }
}

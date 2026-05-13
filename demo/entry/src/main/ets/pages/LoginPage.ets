import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { userProfile } from '../data/AppState';
import { setCurrentUser } from '../data/CurrentUser';
import { showToast, pushUrl } from '../utils/UiFeedback';

interface LoginResponseData {
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

interface LoginResponse {
  code: number;
  message: string;
  data: LoginResponseData | null;
}

interface LoginRequestBody {
  account: string;
  password: string;
}


@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State password: string = '';

  build() {
    Column() {
      Blank();

      Column({ space: 18 }) {
        Column({ space: 12 }) {
          Column() {
            Text('W')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor('#F97316');
          }
          .width(80)
          .height(80)
          .borderRadius(40)
          .backgroundColor('#FFE7CF')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center);

          Text('晨读计划')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2F2A24');

          Text('坚持学习，让每天的进步看得见')
            .fontSize(14)
            .fontColor('#7C6754');
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);

        Column({ space: 12 }) {
          Text('账号')
            .width('100%')
            .fontSize(14)
            .fontColor('#7C6754');

          TextInput({ text: this.account, placeholder: '请输入账号' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .onChange((value: string) => {
              this.account = value;
            });

          Text('密码')
            .width('100%')
            .fontSize(14)
            .fontColor('#7C6754');

          TextInput({ text: this.password, placeholder: '请输入密码' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .onChange((value: string) => {
              this.password = value;
            });

          Row() {
            Text('每次启动需重新登录')
              .fontSize(13)
              .fontColor('#7C6754');
          }
          .width('100%')
          .padding({ top: 4, bottom: 4 });

          Button('登录')
            .width('100%')
            .height(48)
            .backgroundColor('#F97316')
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .borderRadius(22)
            .onClick(() => {
              try {
                if (!this.account.trim() || !this.password.trim()) {
                  showToast(this.getUIContext(), '请输入账号和密码');
                  return;
                }

                const requestBody: LoginRequestBody = {
                  account: this.account.trim(),
                  password: this.password.trim()
                };

                ApiService.post('/api/auth/login', requestBody)
                  .then((result: string) => {
                    try {
                      const response = JSON.parse(result) as LoginResponse;

                      if (response.code !== 200 || response.data === null) {
                        showToast(this.getUIContext(), response.message);
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
                      setCurrentUser(response.data.id, response.data.account, response.data.nickname);

                      showToast(this.getUIContext(), '登录成功');

                      try {
                        pushUrl(this.getUIContext(), 'pages/MainPage');
                      } catch (error) {
                        const err = error as BusinessError;
                        console.error('router failed: ' + err.message);
                      }
                    } catch (error) {
                      const err = error as BusinessError;
                      showToast(this.getUIContext(), '登录响应解析失败');
                      console.error('parse failed: ' + err.message);
                    }
                  })
                  .catch((error: BusinessError) => {
                    showToast(this.getUIContext(), '登录失败，请检查网络或后端服务');
                    console.error('login failed: ' + error.message);
                  });
              } catch (error) {
                const err = error as BusinessError;
                console.error('login click failed: ' + err.message);
              }
            });

          Row({ space: 6 }) {
            Text('还没有账号？')
              .fontSize(13)
              .fontColor('#8A8179');

            Text('去注册')
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor('#F97316')
              .onClick(() => {
                pushUrl(this.getUIContext(), 'pages/RegisterPage');
              });
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 4 });


        }
        .width('100%')
        .padding(18)
        .backgroundColor('#FFFDF9')
        .borderRadius(28);
      }
      .width('100%')
      .padding({ left: 20, right: 20 });

      Blank();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF8F3');
  }
}

@Preview
@Component
struct LoginPagePreview {
  build() {
    LoginPage();
  }
}

import { ApiService } from '../api/ApiService';
import { BusinessError } from '@kit.BasicServicesKit';
import { userProfile } from '../data/AppState';
import { setCurrentUser } from '../data/CurrentUser';
import { showToast, pushUrl, routerBack } from '../utils/UiFeedback';

interface RegisterResponseData {
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

interface RegisterResponse {
  code: number;
  message: string;
  data: RegisterResponseData | null;
}

interface RegisterRequestBody {
  account: string;
  password: string;
  nickname: string;
}

@Entry
@Component
struct RegisterPage {
  @State account: string = '';
  @State nickname: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';

  register() {
    try {
      const accountText: string = this.account.trim();
      const nicknameText: string = this.nickname.trim();
      const passwordText: string = this.password.trim();
      const confirmPasswordText: string = this.confirmPassword.trim();

      if (!accountText || !passwordText || !confirmPasswordText) {
        showToast(this.getUIContext(), '请输入账号和密码');
        return;
      }

      if (passwordText.length < 6) {
        showToast(this.getUIContext(), '密码至少 6 位');
        return;
      }

      if (passwordText !== confirmPasswordText) {
        showToast(this.getUIContext(), '两次输入的密码不一致');
        return;
      }

      const requestBody: RegisterRequestBody = {
        account: accountText,
        password: passwordText,
        nickname: nicknameText
      };

      ApiService.post('/api/auth/register', requestBody)
        .then((result: string) => {
          try {
            const response = JSON.parse(result) as RegisterResponse;

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

            showToast(this.getUIContext(), '注册成功');
            pushUrl(this.getUIContext(), 'pages/MainPage');
          } catch (error) {
            const err = error as BusinessError<number>;
            showToast(this.getUIContext(), '注册响应解析失败');
            console.error('register parse failed: ' + err.message);
          }
        })
        .catch((error: BusinessError<number>) => {
          showToast(this.getUIContext(), '注册失败，请检查网络或后端服务');
          console.error('register failed: ' + error.message);
        });
    } catch (error) {
      const err = error as BusinessError<number>;
      console.error('register click failed: ' + err.message);
    }
  }

  build() {
    Column() {
      Row() {
        Text('< 返回')
          .fontSize(14)
          .fontColor('#F97316')
          .onClick(() => {
            routerBack(this.getUIContext());
          });

        Blank();
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 10 });

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

          Text('创建账号')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2F2A24');

          Text('注册后直接进入晨读计划')
            .fontSize(14)
            .fontColor('#7C6754');
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);

        Column({ space: 12 }) {
          this.inputLabel('账号');
          TextInput({ text: this.account, placeholder: '请输入账号' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .onChange((value: string) => {
              this.account = value;
            });

          this.inputLabel('昵称');
          TextInput({ text: this.nickname, placeholder: '请输入昵称，可不填' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .onChange((value: string) => {
              this.nickname = value;
            });

          this.inputLabel('密码');
          TextInput({ text: this.password, placeholder: '请输入至少 6 位密码' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            });

          this.inputLabel('确认密码');
          TextInput({ text: this.confirmPassword, placeholder: '请再次输入密码' })
            .height(52)
            .backgroundColor('#FFF7ED')
            .borderRadius(18)
            .padding({ left: 16, right: 16 })
            .fontSize(15)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.confirmPassword = value;
            });

          Button('注册并登录')
            .width('100%')
            .height(48)
            .backgroundColor('#F97316')
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .borderRadius(22)
            .margin({ top: 8 })
            .onClick(() => {
              this.register();
            });
        }
        .width('100%')
        .padding(18)
        .backgroundColor('#FFFDF9')
        .borderRadius(28);

        Row({ space: 6 }) {
          Text('已有账号？')
            .fontSize(13)
            .fontColor('#8A8179');
          Text('返回登录')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#F97316')
            .onClick(() => {
              routerBack(this.getUIContext());
            });
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20 });

      Blank();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF8F3');
  }

  @Builder
  inputLabel(text: string) {
    Text(text)
      .width('100%')
      .fontSize(14)
      .fontColor('#7C6754');
  }
}

@Preview
@Component
struct RegisterPagePreview {
  build() {
    RegisterPage();
  }
}

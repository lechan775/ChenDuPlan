import { UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

export function showToast(uiContext: UIContext, message: string): void {
  try {
    uiContext.getPromptAction().showToast({ message: message });
  } catch (error) {
    const err = error as BusinessError<number>;
    console.error('show toast failed: ' + err.message);
  }
}

export function pushUrl(uiContext: UIContext, url: string): void {
  try {
    uiContext.getRouter()
      .pushUrl({ url: url })
      .catch((error: BusinessError<number>) => {
        console.error('push url failed: ' + error.message);
      });
  } catch (error) {
    const err = error as BusinessError<number>;
    console.error('push url failed: ' + err.message);
  }
}

export function routerBack(uiContext: UIContext): void {
  try {
    uiContext.getRouter().back();
  } catch (error) {
    const err = error as BusinessError<number>;
    console.error('router back failed: ' + err.message);
  }
}

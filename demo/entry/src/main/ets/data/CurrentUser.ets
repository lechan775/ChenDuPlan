import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

export class CurrentUser {
  id: number = 1;
  account: string = 'demo_user';
  nickname: string = 'Morning Reader';
  isLoggedIn: boolean = false;
}

export const currentUser: CurrentUser = new CurrentUser();

const STORAGE_USER_ID: string = 'currentUserId';
const STORAGE_ACCOUNT: string = 'currentUserAccount';
const STORAGE_NICKNAME: string = 'currentUserNickname';
const STORAGE_LOGGED_IN: string = 'currentUserLoggedIn';
const PREFERENCES_NAME: string = 'current_user';

let userPreferences: preferences.Preferences | null = null;

export function initCurrentUserStorage(context: Context): void {
  try {
    const options: preferences.Options = {
      name: PREFERENCES_NAME
    };

    userPreferences = preferences.getPreferencesSync(context, options);

    const storedIdValue: preferences.ValueType = userPreferences.getSync(STORAGE_USER_ID, currentUser.id);
    const storedAccountValue: preferences.ValueType = userPreferences.getSync(STORAGE_ACCOUNT, currentUser.account);
    const storedNicknameValue: preferences.ValueType = userPreferences.getSync(STORAGE_NICKNAME, currentUser.nickname);
    const storedLoggedInValue: preferences.ValueType = userPreferences.getSync(STORAGE_LOGGED_IN, currentUser.isLoggedIn);

    if (typeof storedLoggedInValue === 'boolean' && storedLoggedInValue && typeof storedIdValue === 'number') {
      const storedAccount: string = typeof storedAccountValue === 'string' ? storedAccountValue : '';
      const storedNickname: string = typeof storedNicknameValue === 'string' ? storedNicknameValue : '';

      currentUser.id = storedIdValue;
      currentUser.account = storedAccount;
      currentUser.nickname = storedNickname;
      currentUser.isLoggedIn = true;
    }
  } catch (error) {
    const err = error as BusinessError<number>;
    console.error('init current user storage failed: ' + err.message);
  }
}

function saveCurrentUser(): void {
  if (userPreferences === null) {
    return;
  }

  try {
    userPreferences.putSync(STORAGE_USER_ID, currentUser.id);
    userPreferences.putSync(STORAGE_ACCOUNT, currentUser.account);
    userPreferences.putSync(STORAGE_NICKNAME, currentUser.nickname);
    userPreferences.putSync(STORAGE_LOGGED_IN, currentUser.isLoggedIn);
    userPreferences.flushSync();
  } catch (error) {
    const err = error as BusinessError<number>;
    console.error('save current user failed: ' + err.message);
  }
}

export function setCurrentUser(id: number, account: string, nickname: string): void {
  currentUser.id = id;
  currentUser.account = account;
  currentUser.nickname = nickname;
  currentUser.isLoggedIn = true;

  saveCurrentUser();
}

export function resetCurrentUser(): void {
  currentUser.id = 1;
  currentUser.account = 'demo_user';
  currentUser.nickname = 'Morning Reader';
  currentUser.isLoggedIn = false;

  saveCurrentUser();
}

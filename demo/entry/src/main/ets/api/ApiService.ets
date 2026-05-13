import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

const BASE_URL: string = API_BASE_URL;

export class ApiService {
  static get(path: string): Promise<string> {
    return new Promise((resolve, reject) => {
      const request = http.createHttp();

      request.request(
        BASE_URL + path,
        {
          method: http.RequestMethod.GET,
          connectTimeout: 15000,
          readTimeout: 15000
        },
        (error, data) => {
          request.destroy();

          if (error) {
            reject(error);
            return;
          }

          resolve(data.result as string);
        }
      );
    });
  }

  static post(path: string, body: object): Promise<string> {
    return new Promise((resolve, reject) => {
      const request = http.createHttp();

      request.request(
        BASE_URL + path,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(body),
          connectTimeout: 15000,
          readTimeout: 15000
        },
        (error, data) => {
          request.destroy();

          if (error) {
            reject(error);
            return;
          }

          resolve(data.result as string);
        }
      );
    });
  }
  static put(path: string, body: object): Promise<string> {
    return new Promise((resolve, reject) => {
      const request = http.createHttp();

      request.request(
        BASE_URL + path,
        {
          method: http.RequestMethod.PUT,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(body),
          connectTimeout: 15000,
          readTimeout: 15000
        },
        (error, data) => {
          request.destroy();

          if (error) {
            reject(error);
            return;
          }

          resolve(data.result as string);
        }
      );
    });
  }

  static delete(path: string): Promise<string> {
    return new Promise((resolve, reject) => {
      const request = http.createHttp();

      request.request(
        BASE_URL + path,
        {
          method: http.RequestMethod.DELETE,
          connectTimeout: 15000,
          readTimeout: 15000
        },
        (error, data) => {
          request.destroy();

          if (error) {
            reject(error);
            return;
          }

          resolve(data.result as string);
        }
      );
    });
  }

}

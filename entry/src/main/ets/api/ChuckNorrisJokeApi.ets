import http from '@ohos.net.http';
import { ChuckJoke } from '../model/ChuckJoke';

const url = 'https://api.chucknorris.io/jokes/random';

export function getRandomJoke(): Promise<ChuckJoke> {
  return new Promise<ChuckJoke>((resolve, reject) => {
    const httpRequest = http.createHttp();

    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'Accept': 'application/json',
      },
      expectDataType: http.HttpDataType.STRING,
      usingCache: true,
      priority: 1,
      connectTimeout: 60000,
      readTimeout: 60000,
      usingProtocol: http.HttpProtocol.HTTP1_1,
    };

    httpRequest.request(url, options, (err, data) => {
      if (!err) {
        if (data && typeof data.result === 'string') {
          try {
            const joke: ChuckJoke = JSON.parse(data.result);
            resolve(joke);
          } catch (parseError) {
            reject(new Error('JSON response parsing error.'));
          }
        } else {
          reject(new Error('Empty answer or not a string'));
        }
      } else {
        reject(new Error(`Request error: ${err.message || JSON.stringify(err)}`));
      }

      httpRequest.destroy();
    });
  });
}

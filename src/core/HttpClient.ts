export class HttpClient {
  public static create(): HttpClient {
    return new HttpClient();
  }

  public async fetch(url: string) {
    try {
      return await fetch(url);
    } catch (e) {
      throw new Error(`${e}: ${JSON.stringify(e)}`);
    }
  }
}

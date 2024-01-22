export class Scraper {
  public async fetch(url: string) {
    const response = await fetch(url);

    return response.text();
  }
}

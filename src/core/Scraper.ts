import { JSDOM } from "jsdom";

export class Scraper {
  public async fetch(url: string) {
    const response = await fetch(url);

    return response.text();
  }

  public createParser(html: string): Document {
    const dom = new JSDOM(html);

    return dom.window.document;
  }
}

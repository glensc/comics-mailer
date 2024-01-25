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

  public metaProperty(document: Document, name: string) {
    const element = document.querySelector(`meta[property='${name}']`);

    return element?.getAttribute("content");
  }

  public textContent(document: Document, selector: string) {
    return document.querySelector(selector)?.textContent;
  }
}

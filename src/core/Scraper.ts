import { JSDOM } from "jsdom";

export class Scraper {
  public async fetch(url: string) {
    let response;
    try {
      response = await fetch(url);
    } catch (e) {
      throw new Error(`${e}: ${JSON.stringify(e)}`);
    }

    return response.text();
  }

  public createParser(html: string): Document {
    const dom = new JSDOM(html);

    return dom.window.document;
  }

  public forceHttps<T extends string | null | undefined>(url: T): T | string {
    if (!url) {
      return url;
    }

    const link = new URL(url);
    link.protocol = "https:";

    return String(link);
  }

  public metaProperty(document: Document, name: string) {
    const element = document.querySelector(`meta[property='${name}']`);

    return element?.getAttribute("content");
  }

  public ogImage(document: Document) {
    return this.metaProperty(document, "og:image");
  }

  public ogUrl(document: Document) {
    return this.metaProperty(document, "og:url");
  }

  public textContent(document: Document, selector: string) {
    return document.querySelector(selector)?.textContent;
  }
}

import { Comic } from "./Comic.ts";
import { JSDOM } from "jsdom";
import type { HttpClient } from "./HttpClient.ts";

export class Scraper {
  public constructor(
    private readonly httpClient: HttpClient,
  ) {
  }

  public async fetch(url: string) {
    const response = await this.httpClient.fetch(url);

    return response.text();
  }

  public createParser(html: string): Document {
    const dom = new JSDOM(html);

    return dom.window.document;
  }

  public async getDocumentFromUrl(url: string) {
    return this.createParser(await this.fetch(url));
  }

  public forceHttps<T extends string | undefined>(url: T): T | string {
    if (!url) {
      return url;
    }

    const link = new URL(url);
    link.protocol = "https:";

    return String(link);
  }

  public metaProperty(document: Document, name: string) {
    const element = document.querySelector(`meta[property='${name}']`);

    return element?.getAttribute("content") || undefined;
  }

  public ogImage(document: Document) {
    return this.metaProperty(document, "og:image");
  }

  public ogUrl(document: Document) {
    return this.metaProperty(document, "og:url");
  }

  public textContent(document: Document, selector: string) {
    return document.querySelector(selector)?.textContent || undefined;
  }

  public comic(img?: string, alt?: string, url?: string) {
    if (!img || !alt || !url) {
      return;
    }

    return new Comic(
      img,
      alt,
      url,
    );
  }
}

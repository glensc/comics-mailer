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

  public linkPreloads(document: Document) {
    const links = document.querySelectorAll<HTMLLinkElement>(`link[rel="preload"][as="image"]`);

    const urls = [];
    for (const link of links) {
      urls.push(link.href);
    }

    return urls;
  }

  public nextData(document: Document) {
    const jsonData = document.querySelector<HTMLScriptElement>(`script[id="__NEXT_DATA__"][type="application/json"]`);

    if (!jsonData?.textContent) {
      return null;
    }

    return JSON.parse(jsonData.textContent);
  }

  public nextDataUrlState(document: Document) {
    const nextData = this.nextData(document);

    const states = [];
    for (const state of Object.values<{ data: string }>(nextData.props.pageProps.urqlState)) {
      states.push(JSON.parse(state.data));
    }

    return states;
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

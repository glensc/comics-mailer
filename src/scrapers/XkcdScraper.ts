import type { Scraper, ScraperInterface } from "../core";

export class XkcdScraper implements ScraperInterface {
  private readonly url = "https://xkcd.com";

  public async scrape(scraper: Scraper) {
    const document = await scraper.getDocumentFromUrl(this.url);
    const element = document.querySelector("div#comic img");
    const title = element?.getAttribute("title") || undefined;
    const imgurl = scraper.ogImage(document);
    const url = scraper.ogUrl(document);

    return scraper.comic(imgurl, title, url);
  }
}

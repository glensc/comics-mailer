import type { Scraper, ScraperInterface } from "../core";

export class XkcdScraper implements ScraperInterface {
  private url = "https://xkcd.com";

  public async scrape(scraper: Scraper) {
    const document = scraper.createParser(await scraper.fetch(this.url));

    const element = document.querySelector("div#comic img");
    const title = element?.getAttribute("title");
    const imgurl = scraper.ogImage(document);
    const url = scraper.ogUrl(document);

    if (!imgurl || !title || !url) {
      return;
    }

    return ([imgurl, title, url]);
  }
}

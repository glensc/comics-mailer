import type { Scraper, ScraperInterface } from "../core";

export class WumoScraper implements ScraperInterface {
  private readonly url = "https://wumo.com";

  public async scrape(scraper: Scraper) {
    const document = await scraper.getDocumentFromUrl(this.url);
    const img = document.querySelector("div.box-content img");
    const src = img?.getAttribute("src");
    const alt = img?.getAttribute("alt");

    if (!src || !alt) {
      return;
    }

    const imgurl = new URL(src, this.url).href;

    return ([imgurl, alt, this.url]);
  }
}

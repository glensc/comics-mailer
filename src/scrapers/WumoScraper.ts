import type { Scraper, ScraperInterface } from "../core";

export class WumoScraper implements ScraperInterface {
  private readonly url = "https://wumo.com";

  public async scrape(scraper: Scraper) {
    const document = await scraper.getDocumentFromUrl(this.url);
    const img = document.querySelector("div.box-content img");
    const src = img?.getAttribute("src");
    const alt = img?.getAttribute("alt") || undefined;
    const imgurl = src ? new URL(src, this.url).href : undefined;

    return scraper.comic(imgurl, alt, this.url);
  }
}

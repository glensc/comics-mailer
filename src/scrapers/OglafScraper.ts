import type { Scraper, ScraperInterface } from "../core";

export class OglafScraper implements ScraperInterface {
  private readonly url = "https://oglaf.com";

  public async scrape(scraper: Scraper) {
    const document = await scraper.getDocumentFromUrl(this.url);
    const element = document.querySelector("img[id='strip']");
    const src = element?.getAttribute("src");
    const alt = element?.getAttribute("alt");

    if (!src || !alt) {
      return;
    }

    return ([src, alt, this.url]);
  }
}

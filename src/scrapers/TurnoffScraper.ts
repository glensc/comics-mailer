import { Scraper } from "../core/Scraper.ts";
import type { ScraperInterface } from "../core/ScraperInterface.ts";

export class TurnoffScraper implements ScraperInterface {
  private url = "https://turnoff.us";

  public async scrape(scraper: Scraper) {
    const feedUrl = new URL("/feed.xml", this.url);
    const content = await scraper.fetch(String(feedUrl));
    const document = scraper.createParser(content);

    const link = document.querySelector("rss channel item guid")?.textContent;
    if (!link) {
      return;
    }

    const pageContent = await scraper.fetch(link);
    const pageDocument = scraper.createParser(pageContent);

    const title = scraper.metaProperty(pageDocument, "og:title");
    const img = scraper.metaProperty(pageDocument, "og:image");

    if (!img || !title) {
      return;
    }

    return ([img, title, link]);
  }
}

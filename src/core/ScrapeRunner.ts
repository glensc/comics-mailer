import type { ScraperInterface } from "./ScraperInterface.ts";
import type { Scraper } from "./Scraper.ts";

export class ScrapeRunner {
  public constructor(
    private readonly scraper: Scraper,
  ) {
  }

  public async run(scrapers: ScraperInterface[]) {
    const collected = [];
    const promises = Promise.all(Array.from(this.prepare(scrapers)));
    for await (const result of await promises) {
      if (!result) {
        continue;
      }

      collected.push(result);
    }

    return collected;
  }

  private* prepare(scrapers: ScraperInterface[]) {
    for (const scraper of scrapers) {
      yield scraper.scrape(this.scraper);
    }
  }
}

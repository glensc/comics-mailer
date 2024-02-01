import type { AttachmentBuilder } from "./AttachmentBuilder.ts";
import type { Comic } from "./Comic.ts";
import type { ScraperInterface } from "./ScraperInterface.ts";
import type { Scraper } from "./Scraper.ts";

export class ScrapeRunner {
  public constructor(
    private readonly scraper: Scraper,
    private readonly ab: AttachmentBuilder,
  ) {
  }

  public async run(scrapers: ScraperInterface[]) {
    const comics = await this.scrape(scrapers);
    const attachments = await this.getAttachments(comics);

    return attachments;
  }

  private async getAttachments(scraped: Comic[]) {
    return Promise.all(Array.from(this.prepareAttachments(scraped)));
  }

  private* prepareAttachments(comics: Comic[]) {
    for (const comic of comics) {
      yield this.ab.create(comic);
    }
  }

  private async scrape(scrapers: ScraperInterface[]) {
    const collected = [];
    const promises = Promise.all(Array.from(this.prepare(scrapers)));
    for await (const comic of await promises) {
      if (!comic) {
        continue;
      }

      collected.push(comic);
    }

    return collected;
  }

  private* prepare(scrapers: ScraperInterface[]) {
    for (const scraper of scrapers) {
      yield scraper.scrape(this.scraper);
    }
  }
}

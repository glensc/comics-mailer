import type { AttachmentBuilder } from "./AttachmentBuilder.ts";
import type { ScraperInterface } from "./ScraperInterface.ts";
import type { Scraper } from "./Scraper.ts";

export class ScrapeRunner {
  public constructor(
    private readonly scraper: Scraper,
    private readonly ab: AttachmentBuilder,
  ) {
  }

  public async run(scrapers: ScraperInterface[]) {
    const scraped = await this.scrape(scrapers);
    const attachments = await this.getAttachments(scraped);

    return attachments;
  }

  private async getAttachments(scraped: string[][]) {
    return Promise.all(Array.from(this.prepareAttachments(scraped)));
  }

  private* prepareAttachments(scraped: string[][]) {
    for (const [url, description, baseUrl] of scraped) {
      yield this.ab.create(url, description, baseUrl);
    }
  }

  private async scrape(scrapers: ScraperInterface[]) {
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

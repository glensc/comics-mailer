import type { Scraper, ScraperInterface } from "../core";

export class TurnoffScraper implements ScraperInterface {
  private url = "https://turnoff.us";

  public async scrape(scraper: Scraper) {
    const feedUrl = new URL("/feed.xml", this.url);
    const content = await scraper.fetch(String(feedUrl));
    const document = scraper.createParser(content);

    let link = scraper.forceHttps(
      scraper.textContent(document, "rss channel item guid")
    );

    if (!link) {
      return;
    }

    // https://github.com/oven-sh/bun/issues/8599
    if (link[-1] !== "/") {
      link += "/";
    }

    const pageContent = await scraper.fetch(link);
    const pageDocument = scraper.createParser(pageContent);

    const title = scraper.metaProperty(pageDocument, "og:title");
    const img = scraper.forceHttps(scraper.metaProperty(pageDocument, "og:image"));

    if (!img || !title) {
      return;
    }

    return ([img, title, link]);
  }
}

import type { Scraper, ScraperInterface } from "../core";

export class TurnoffScraper implements ScraperInterface {
  private readonly url = "https://turnoff.us";

  public async scrape(scraper: Scraper) {
    const feedUrl = String(new URL("/feed.xml", this.url));
    const document = await scraper.getDocumentFromUrl(feedUrl);
    const link = this.getLink(scraper, document);
    if (!link) {
      return;
    }

    const pageContent = await scraper.fetch(link);
    const pageDocument = scraper.createParser(pageContent);
    const title = scraper.metaProperty(pageDocument, "og:title");
    const img = scraper.forceHttps(scraper.metaProperty(pageDocument, "og:image"));

    return scraper.comic(img, title, link);
  }

  private getLink(scraper: Scraper, document: Document) {
    let link = scraper.forceHttps(
      scraper.textContent(document, "rss channel item guid"),
    );
    if (!link) {
      return;
    }

    // https://github.com/oven-sh/bun/issues/8599
    if (link[-1] !== "/") {
      link += "/";
    }

    return link;
  }
}

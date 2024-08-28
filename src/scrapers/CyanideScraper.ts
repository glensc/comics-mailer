import type { Scraper, ScraperInterface } from "../core";

export class CyanideScraper implements ScraperInterface {
  private readonly url = "https://www.explosm.net";

  public async scrape(scraper: Scraper) {
    const document = await scraper.getDocumentFromUrl(this.url);

    const urqlState = scraper.nextDataUrlState(document);
    const comicData = urqlState.filter(element => !!element.comic)?.[0].comic;

    const imgurl = comicData.comicDetails.comicimgstaticbucketurl.mediaItemUrl;
    const title = comicData.title;
    const slug = comicData.slug;

    const url = `https://explosm.net/comics/${slug}#comic`;

    return scraper.comic(imgurl, title, url);
  }
}

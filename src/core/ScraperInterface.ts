import { type Scraper } from "./Scraper.ts";

export type ScraperInterface = {
  scrape(scraper: Scraper): Promise<string[] | undefined>;
};

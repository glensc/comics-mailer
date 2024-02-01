import { Scraper } from "./Scraper.ts";

export interface ScraperInterface {
  scrape(scraper: Scraper): Promise<string[] | undefined>;
};

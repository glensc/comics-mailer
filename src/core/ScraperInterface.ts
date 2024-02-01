import { type Scraper } from "./Scraper.ts";
import { Comic } from "./Comic.ts";

export type ScraperInterface = {
  scrape(scraper: Scraper): Promise<Comic | undefined>;
};

export interface ScraperInterface {
  scrape(): Promise<string[] | undefined>;
}

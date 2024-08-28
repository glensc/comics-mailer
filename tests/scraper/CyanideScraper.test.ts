import { HttpClient, Scraper } from "../../src/core";
import { CyanideScraper } from "../../src/scrapers/CyanideScraper";

const test = async () => {
  const scraper = new Scraper(HttpClient.create());
  const comic = new CyanideScraper();
  const result = await comic.scrape(scraper);

  console.log(result);
};

test()
  .catch(e => {
    console.error(e.message);
  });

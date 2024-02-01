import { TurnoffScraper } from "../../src/scrapers/TurnoffScraper.ts";
import { HttpClient, Scraper } from "../../src/core";

const test = async () => {
  const scraper = new Scraper(HttpClient.create());
  const comic = new TurnoffScraper();
  const result = await comic.scrape(scraper);

  console.log(result);
};

test()
  .catch(e => {
    console.error(e.message);
  });

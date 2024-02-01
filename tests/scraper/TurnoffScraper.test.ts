import { TurnoffScraper } from "../../src/scrapers/TurnoffScraper.ts";
import { Scraper } from "../../src/core/Scraper.ts";
import { HttpClient } from "../../src/core/HttpClient.ts";

const test = async () => {
  const scraper = new Scraper(HttpClient.create());
  const comic = new TurnoffScraper();
  const result = await comic.scrape(scraper);

  console.log(result);
};

test()
  .catch(e => console.error(e.message));

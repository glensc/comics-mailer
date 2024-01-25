import { TurnoffScraper } from "../scrapers/TurnoffScraper.ts";
import { WumoScraper } from "../scrapers/WumoScraper.ts";

export default [
  new TurnoffScraper(),
  new WumoScraper(),
];

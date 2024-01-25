import { OglafScraper } from "../scrapers/OglafScraper.ts";
import { TurnoffScraper } from "../scrapers/TurnoffScraper.ts";
import { WumoScraper } from "../scrapers/WumoScraper.ts";

export default [
  new OglafScraper(),
  new TurnoffScraper(),
  new WumoScraper(),
];

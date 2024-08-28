import { CyanideScraper } from "../scrapers/CyanideScraper.ts";
import { OglafScraper } from "../scrapers/OglafScraper.ts";
import { TurnoffScraper } from "../scrapers/TurnoffScraper.ts";
import { WumoScraper } from "../scrapers/WumoScraper.ts";
import { XkcdScraper } from "../scrapers/XkcdScraper.ts";

export default [
  new OglafScraper(),
  new TurnoffScraper(),
  new WumoScraper(),
  new XkcdScraper(),
  new CyanideScraper(),
];

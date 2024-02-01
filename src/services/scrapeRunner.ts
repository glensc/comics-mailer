import { AttachmentBuilder, Scraper, ScrapeRunner } from "../core";
import httpClient from "./httpClient.ts";

export default new ScrapeRunner(
  new Scraper(httpClient),
  new AttachmentBuilder(httpClient),
);

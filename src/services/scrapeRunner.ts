import { AttachmentBuilder, DeliveredState, Scraper, ScrapeRunner } from "../core";
import httpClient from "./httpClient.ts";
import { DELIVERY_STATE_PATH } from "./config.ts";

export default new ScrapeRunner(
  new Scraper(httpClient),
  new AttachmentBuilder(httpClient),
  new DeliveredState(DELIVERY_STATE_PATH),
);

import { HttpClient } from "../core";
import { CACHE_PATH } from "./config.ts";

export default HttpClient.create({
  cacheDirectory: CACHE_PATH,
});

import { HttpClient } from "../src/core";
import { CACHE_PATH } from "../src/services/config.ts";

const test = async () => {
  const httpClient = HttpClient.create({
    cacheDirectory: CACHE_PATH,
  });

  const url = "https://wumo.com/img/wumo/2024/01/wumo65aaaaf604acc7.84412774.jpg";
  const response = await httpClient.fetch(url);
  console.log(response);
};

test()
  .catch(e => {
    console.error(e.message);
  });

import { AttachmentBuilder, Comic, HttpClient } from "../src/core";

const test = async () => {
  const ab = new AttachmentBuilder(HttpClient.create());

  const url = "https://wumo.com/img/wumo/2024/01/wumo65aaaaf604acc7.84412774.jpg";
  const c = new Comic(url, "Wumo 24. Jan 2024", "https://wumo.com/");
  console.log("Attachment", await ab.create(c));
};

test()
  .catch(e => {
    console.error(e.message);
  });

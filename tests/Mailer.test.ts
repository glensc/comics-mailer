import { Mailer } from "../src/core/Mailer.ts";
import { MailTransport } from "../src/core/MailTransport.ts";
import { MailBuilder } from "../src/core/MailBuilder.ts";
import { VIEWS_PATH } from "../src/services/config.ts";
import { AttachmentBuilder } from "../src/core/AttachmentBuilder.ts";
import { HttpClient } from "../src/core/HttpClient.ts";

const test = async () => {
  const mailer = new Mailer(
    new MailBuilder(VIEWS_PATH),
    new MailTransport({
      streamTransport: true,
    }),
  );

  const ab = new AttachmentBuilder(HttpClient.create());
  const url = "https://wumo.com/img/wumo/2024/01/wumo65aaaaf604acc7.84412774.jpg";
  const attachment = await ab.create(url, "Wumo 24. Jan 2024", "https://wumo.com/");

  const info: any = await mailer.send({
    date: new Date(),
    subject: "DAILY: comics at estonian web ({{date}})",
    attachments: [attachment],
  });

  console.log("envelope", info.envelope);
  console.log("messageId", info.messageId);

  if (info.message) {
    info.message.pipe(process.stdout);
  }
};

test()
  .catch(e => console.error(e.message));

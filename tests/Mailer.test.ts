import { Mailer } from "../src/core/Mailer.ts";
import { MailTransport } from "../src/core/MailTransport.ts";
import { MailBuilder } from "../src/core/MailBuilder.ts";
import { VIEWS_PATH } from "../src/services/config.ts";

const test = async () => {
  const mailer = new Mailer(
    new MailBuilder(VIEWS_PATH),
    new MailTransport({
      streamTransport: true,
    }),
  );

  const info: any = await mailer.send({
    date: new Date(),
    subject: "DAILY: comics at estonian web ({{date}})",
  });

  console.log("envelope", info.envelope);
  console.log("messageId", info.messageId);
  info.message.pipe(process.stdout);
};

test()
  .catch(e => console.error(e.message));

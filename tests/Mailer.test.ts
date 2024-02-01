import { Mailer, MailTransport, MailBuilder, AttachmentBuilder, HttpClient } from "../src/core";
import { MAIL_BCC, MAIL_REPLY_TO, VIEWS_PATH } from "../src/services/config.ts";

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
    replyTo: MAIL_REPLY_TO,
    bcc: [MAIL_BCC],
    attachments: [attachment],
  });

  console.log("envelope", info.envelope);
  console.log("messageId", info.messageId);

  if (info.message) {
    info.message.pipe(process.stdout);
  }
};

test()
  .catch(e => {
    console.error(e.message);
  });

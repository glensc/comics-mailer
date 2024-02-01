import scrapers from "./services/scrapers.ts";
import mailer from "./services/mailer.ts";
import scrapeRunner from "./services/scrapeRunner.ts";
import { MAIL_FROM, MAIL_REPLY_TO } from "./services/config.ts";

const main = async (...recipients: string[]) => {
  if (!recipients.length) {
    return;
  }

  const attachments = await scrapeRunner.run(scrapers);

  await mailer.send({
    from: MAIL_FROM,
    date: new Date(),
    subject: "DAILY: Comics from the Internet ({{date}})",
    replyTo: MAIL_REPLY_TO,
    bcc: recipients,
    attachments,
  });
};

if (import.meta.path == Bun.main) {
  await main(...process.argv.slice(2));
}

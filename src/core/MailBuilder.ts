import hbs from "nodemailer-express-handlebars";
import type { MailOptions } from "./MailOptions.ts";
import type { Attachment } from "nodemailer/lib/mailer";

export class MailBuilder {
  public constructor(
    private readonly viewPath: string,
  ) {
  }

  public getRenderPlugin() {
    // Point to the template folder
    const handlebarOptions = {
      viewEngine: {
        partialsDir: this.viewPath,
        defaultLayout: undefined,
      },
      viewPath: this.viewPath,
    };

    // Use a template file with nodemailer
    return hbs(handlebarOptions);
  }

  public build(input: MailOptions) {
    const {
      date = new Date(),
      subject,
      timezone = "Europe/Tallinn",
      context,
      attachments = [],
      ...options
    } = input;

    const formattedDate = new Intl.DateTimeFormat("en-GB", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour12: false,
      timeZone: timezone,
    }).format(date);

    return {
      template: "email",
      subject: subject.replace("{{date}}", formattedDate),
      attachments,
      context: {
        attachments: Array.from(this.formatAttachments(attachments)),
        ...context,
      },
      ...options,
    };
  }

  private* formatAttachments(attachments: Attachment[]) {
    for (const attachment of attachments) {
      const { description } = (attachment as any);
      const { link } = (attachment as any);
      const { cid } = attachment;

      yield {
        description,
        link,
        cid,
      };
    }
  }
}

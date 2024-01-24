import { createTransport } from "nodemailer";

export class MailTransport {
  private transporter;

  public constructor(options: any) {
    this.transporter = createTransport(options);
  }

  public setRenderPlugin(renderPlugin: any) {
    this.transporter.use("compile", renderPlugin);
  }

  public async send(mailOptions: any) {
    return await this.transporter.sendMail(mailOptions);
  }
}
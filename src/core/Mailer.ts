import type { MailBuilder } from "./MailBuilder.ts";
import type { MailTransport } from "./MailTransport.ts";
import type { MailOptions } from "./MailOptions.ts";

export class Mailer {
  public constructor(
    private readonly builder: MailBuilder,
    private readonly transport: MailTransport,
  ) {
  }

  public async send(options: MailOptions) {
    this.transport.setRenderPlugin(this.builder.getRenderPlugin());

    const sendOptions = this.builder.build(options);

    return await this.transport.send(sendOptions);
  }
}

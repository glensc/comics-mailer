import type { HttpClient } from "./HttpClient.ts";
import { basename } from "node:path";
import { createHash } from "node:crypto";

export class AttachmentBuilder {
  public constructor(
    private readonly client: HttpClient,
  ) {
  }

  public async create(url: string, title: string, rootUrl: string) {
    const response = await this.client.fetch(url);
    const content = Buffer.from(await response.arrayBuffer());

    const attachment = {
      filename: this.getFilename(url),
      cid: this.createContentId(content),
      contentType: response.headers.get("Content-Type") || undefined,
      content,
      description: title,
      link: rootUrl,
    };

    return attachment;
  }

  private createContentId(content: Buffer) {
    return createHash("md5")
      .update(content)
      .digest("base64url");
  }

  private getFilename(url: string) {
    return basename(new URL(url).pathname);
  }
}

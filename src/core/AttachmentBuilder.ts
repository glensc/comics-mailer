import type { Comic } from "./Comic.ts";
import type { HttpClient } from "./HttpClient.ts";
import { basename } from "node:path";
import { createHash } from "node:crypto";

export class AttachmentBuilder {
  public constructor(
    private readonly client: HttpClient,
  ) {
  }

  public async create(comic: Comic) {
    const response = await this.client.fetch(comic.img);
    const content = Buffer.from(await response.arrayBuffer());

    const attachment = {
      filename: this.getFilename(comic.img),
      cid: this.createContentId(content),
      contentType: response.headers.get("Content-Type") || undefined,
      content,
      description: comic.title,
      link: comic.url,
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

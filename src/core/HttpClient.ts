import NodeFetchCache, { FileSystemCache, MemoryCache } from "node-fetch-cache";
import type { NodeFetch } from "./types.ts";

type HttpClientOptions = {
  cacheDirectory?: string;
};

export class HttpClient {
  public constructor(
    private readonly client: NodeFetch,
  ) {
  }

  public static create({ cacheDirectory }: HttpClientOptions = {}): HttpClient {
    const cache = cacheDirectory ? new FileSystemCache({
      // Specify where to keep the cache. If undefined, '.cache' is used by default.
      // If this directory does not exist, it will be created.
      cacheDirectory,
    }) : new MemoryCache();

    return new HttpClient(
      NodeFetchCache.create({
        cache,
      }));
  }

  public async fetch(url: string) {
    return this.client(url);
  }
}

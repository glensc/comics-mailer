import type fetch from "node-fetch";

type FetchFunction = typeof fetch;
type FetchArguments = Parameters<FetchFunction>;
type RequestInfo = FetchArguments[0];
type RequestInit = FetchArguments[1];
type FetchReturn = ReturnType<FetchFunction>;

// Massive trickery because NodeFetchCache.create() doesn't create function compatible with node-fetch namespace.
export type NodeFetch = (url: RequestInfo, init?: RequestInit) => FetchReturn;

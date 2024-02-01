import { join } from "path";

const env = process.env;

export const GMAIL_USERNAME = env.GMAIL_USERNAME || "";
export const GMAIL_PASSWORD = env.GMAIL_PASSWORD || "";

export const VIEWS_PATH = join(__dirname, "../views");

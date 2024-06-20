import { join } from "path";

const { env } = process;

export const GMAIL_USERNAME = env.GMAIL_USERNAME || "";
export const GMAIL_PASSWORD = env.GMAIL_PASSWORD || "";
export const MAIL_FROM = env.MAIL_FROM || "";
export const MAIL_REPLY_TO = env.MAIL_REPLY_TO || "";
export const MAIL_BCC = env.MAIL_BCC || "";

export const VIEWS_PATH = join(__dirname, "../views");
export const DELIVERY_STATE_PATH = join(__dirname, "../delivery-state.json");

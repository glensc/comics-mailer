import { MailTransport } from "../core";
import { GMAIL_PASSWORD, GMAIL_USERNAME } from "./config.ts";

const options = {
  service: "gmail",
  auth: {
    user: GMAIL_USERNAME,
    pass: GMAIL_PASSWORD,
  },
};

export default new MailTransport(options);

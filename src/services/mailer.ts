import { Mailer } from "../core";
import mailTransport from "./mailTransport.ts";
import mailBuilder from "./mailBuilder.ts";

export default new Mailer(
  mailBuilder,
  mailTransport,
)

import mailTransport from "./mailTransport.ts";
import { Mailer } from "../core/Mailer.ts";
import mailBuilder from "./mailBuilder.ts";

export default new Mailer(
  mailBuilder,
  mailTransport,
)

import type { Attachment } from "nodemailer/lib/mailer";

export type MailOptions = {
  date?: Date;
  from?: string;
  replyTo?: string;
  bcc?: string[];
  subject: string;
  timezone?: string;
  context?: any;
  attachments?: Attachment[];
};

import { Router } from "express";
import {
  requireSupportConfigured,
  rawAttachmentBody,
  listTickets,
  createTicket,
  getTicket,
  replyToTicket,
  uploadAttachment,
} from "../controllers/SupportController.js";
import { authenticateToken, authorizeRoles } from "../middlewares/auth.middleware.js";

const supportRouter = Router();

// Dashboard staff only; closed with a 503 until PLEXIVIA_SUPPORT_KEY is set
supportRouter.use(authenticateToken, authorizeRoles("Owner", "Admin", "Manager"), requireSupportConfigured);

supportRouter.get("/tickets", listTickets);
supportRouter.post("/tickets", createTicket);
supportRouter.get("/tickets/:id", getTicket);
supportRouter.post("/tickets/:id/messages", replyToTicket);
// Raw bytes (not multipart); the body parser runs only after auth so anonymous callers never get buffered
supportRouter.post("/attachments", rawAttachmentBody, uploadAttachment);

export default supportRouter;

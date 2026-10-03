import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Presigned R2 uploads for bounty clearance photos and hub captures.
 *
 * Endpoint is added in the Module C step:
 *   POST /uploads/presign
 */
export const uploadRoutes = new Hono<AppEnv>();

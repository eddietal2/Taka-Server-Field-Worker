import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Offline write-ahead queue flush. One idempotent batch endpoint:
 *   POST /sync/batch
 */
export const syncRoutes = new Hono<AppEnv>();

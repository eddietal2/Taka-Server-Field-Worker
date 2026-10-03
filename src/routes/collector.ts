import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Module A — collector daily routes, stop status updates, and GPS plot locking.
 *
 * Endpoints are added in the Module A step:
 *   GET  /collector/routes/today
 *   POST /collector/routes/:routeId/stops/:stopId/status
 *   POST /collector/routes/:routeId/stops/:stopId/lock-gps
 */
export const collectorRoutes = new Hono<AppEnv>();

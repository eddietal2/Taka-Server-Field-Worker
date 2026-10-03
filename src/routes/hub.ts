import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Module B — duka hub weigh-ins, live material rates, and wallet ledger credit.
 *
 * Endpoints are added in the Module B step:
 *   GET  /hub/:hubId/rates
 *   POST /hub/:hubId/sellers/lookup
 *   POST /hub/:hubId/weigh-ins
 */
export const hubRoutes = new Hono<AppEnv>();

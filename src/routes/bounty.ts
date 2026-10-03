import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Module C — responder bounty dispatch, claim expiry, proof verification, and
 * escrow release.
 *
 * Endpoints are added in the Module C step:
 *   GET  /bounties/nearby
 *   POST /bounties/:jobId/claim
 *   POST /bounties/:jobId/proof
 */
export const bountyRoutes = new Hono<AppEnv>();

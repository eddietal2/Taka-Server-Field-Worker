import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * The signed-in field worker's own account.
 *
 * Endpoints are added in the auth step:
 *   GET   /users/me
 *   PATCH /users/me
 *   POST  /users/me/roles
 */
export const usersRoutes = new Hono<AppEnv>();

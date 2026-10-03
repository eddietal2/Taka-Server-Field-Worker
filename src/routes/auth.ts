import { Hono } from 'hono';

import type { AppEnv } from '../types.js';

/**
 * Phone + OTP authentication for field-worker accounts.
 *
 * Endpoints are added in the auth implementation step:
 *   POST /auth/otp/request
 *   POST /auth/otp/verify
 *   POST /auth/login
 *   POST /auth/register
 */
export const authRoutes = new Hono<AppEnv>();

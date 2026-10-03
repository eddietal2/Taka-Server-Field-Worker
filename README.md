# taka-server-field-worker

Backend API for the Taka Smart Waste field-worker apps (Collectors, Duka Agents, Responders).

This directory is intentionally empty apart from this README — it is the starting point
for the backend described in
[`../taka-app-field-worker/plans/taka-app-field-worker.md`](../taka-app-field-worker/plans/taka-app-field-worker.md).

## Purpose

- **Module A** — collector daily routes, stop status updates, and GPS plot locking.
- **Module B** — duka hub weigh-ins, live material rates, and wallet ledger credits.
- **Module C** — responder bounty dispatch, claim expiry, proof verification, and escrow release.
- **Sync** — an idempotent `POST /api/v1/sync/batch` endpoint backed by a unique idempotency-key
  store so retried financial credits never double-apply.

## Planned stack

Mirrors [`taka-server-resident`](../taka-server-resident):

- Hono + `@hono/node-server`
- Prisma + Neon Postgres
- `zod` validation, `jose` JWTs
- OTP auth via the existing provider adapter pattern
- R2 presigned uploads for proof photos
- `vitest` tests, `tsx` dev runner, Vercel deploy

See the full build plan linked above before scaffolding.

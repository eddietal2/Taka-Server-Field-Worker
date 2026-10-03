import { describe, expect, it } from 'vitest';

import { app } from '../src/index.js';

/**
 * Scaffold contract tests. They boot the Hono app without touching a database,
 * so they only cover the routes that exist before the module handlers land.
 */
describe('service routes', () => {
  it('answers the root probe', async () => {
    const res = await app.request('/');
    expect(res.status).toBe(200);

    const body = (await res.json()) as { name?: string; status?: string };
    expect(body.name).toBe('taka-server-field-worker');
    expect(body.status).toBe('ok');
  });

  it('answers the health probe', async () => {
    const res = await app.request('/api/v1/health');
    expect(res.status).toBe(200);

    const body = (await res.json()) as { status?: string };
    expect(body.status).toBe('ok');
  });

  it('returns a JSON envelope for unknown routes', async () => {
    const res = await app.request('/api/v1/nope');
    expect(res.status).toBe(404);

    const body = (await res.json()) as { message?: string };
    expect(body.message).toBe('Not found.');
  });
});

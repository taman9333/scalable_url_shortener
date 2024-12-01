// This load testing is to evaluate the server's performance, including:
// - Number of requests the server can handle
// - Average and maximum response times
// - Requests per second (RPS)

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 500,
  duration: '1s'
  // iterations: 3000,
};

export default function () {
  const url = 'http://host.docker.internal:9292/shorten';
  const payload = JSON.stringify({ url: `http://test.com/page-${__VU}-${__ITER}` });
  const params = { headers: { 'Content-Type': 'application/json' } };

  const res = http.post(url, payload, params);

  check(res, {
    'is status 200': (r) => r.status === 200,
    'has short_url': (r) => {
      try {
        const json = JSON.parse(r.body);
        return json.short_url !== undefined;
      } catch (e) {
        console.error('Failed to parse JSON:', e.message);
        return false;
      }
    },
  });
}
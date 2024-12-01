// This load testing is designed to test two instances of the URL shortener service.
// It ensures that both instances can work concurrently and get counter ranges to shorten the url
// without causing conflicts or failures

import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 100,
  duration: '1s'
};

const urls = [
  'http://host.docker.internal:9292/shorten',
  'http://host.docker.internal:9293/shorten',
];

export default function () {
  const url = urls[__ITER % urls.length]; // Alternate between URLs (round-robin)

  const payload = JSON.stringify({ url: `http://test.com/page-${__VU}-${__ITER}` });
  const params = { headers: { 'Content-Type': 'application/json' } };

  const res = http.post(url, payload, params);

  check(res, {
    'is status 200': (r) => r.status === 200,
    'has short_url': (r) => JSON.parse(r.body).short_url !== undefined,
  });
}
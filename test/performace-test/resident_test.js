import http from 'k6/http';
import { check, sleep } from 'k6';
import { BASE_URL } from './config.js';

export const options = {
  vus: 30,
  duration: '30s',
};

export default function () {
  const res = http.get(`${BASE_URL}/residents?search=an`);

  check(res, {
    'status 200': (r) => r.status === 200,
  });

  sleep(1);
}

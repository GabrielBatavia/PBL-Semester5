import http from 'k6/http';
import { check } from 'k6';
import { BASE_URL, DEFAULT_HEADERS } from './config.js';

export default function loginTest() {
  const payload = JSON.stringify({
    email: 'admin@jawara.com',
    password: '123456',
  });

  const res = http.post(
    `${BASE_URL}/auth/login`,
    payload,
    { headers: DEFAULT_HEADERS }
  );

  const ok = check(res, {
    'login status 200': (r) => r && r.status === 200,
  });

  if (!ok || !res.body) {
    return null;   
  }

  const body = res.json();
  return body.access_token; 
}

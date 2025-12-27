import http from 'k6/http';
import { check, sleep } from 'k6';
import { BASE_URL, DEFAULT_HEADERS } from './config.js';

export const options = {
  vus: 15,
  duration: '30s',
};

export default function () {
  const payload = JSON.stringify({
    family_id: 1,
    old_address: 'Alamat Lama',
    new_address: 'Alamat Baru',
    mutation_type: 'pindah',
    reason: 'Testing',
    date: '2025-01-01',
  });

  const res = http.post(`${BASE_URL}/mutasi`, payload, {
    headers: DEFAULT_HEADERS,
  });

  check(res, {
    'mutasi created': (r) => r.status === 200 || r.status === 201,
  });

  sleep(1);
}

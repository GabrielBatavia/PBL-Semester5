import http from 'k6/http';
import { sleep, check } from 'k6';
import { BASE_URL } from './config.js';

export const options = {
  stages: [
    { duration: '10s', target: 5 },
    { duration: '20s', target: 20 },
    { duration: '20s', target: 50 },
    { duration: '10s', target: 0 },
  ],
};

export default function () {
  const url = `${BASE_URL}/reports/generate?report_type=semua&start_date=2025-01-01&end_date=2025-12-31`;

  const res = http.get(url);

  check(res, {
    'PDF generated': (r) => r.status === 200,
  });

  sleep(2);
}
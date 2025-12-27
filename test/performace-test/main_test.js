import { group, sleep } from 'k6';

import loginTest from './login_test.js';
import residentTest from './resident_test.js';
import mutasiTest from './mutasi_test.js';
import reportTest from './report_stress.js';

import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.4/index.js';

export const options = {
  stages: [
    { duration: '30s', target: 10 },
    { duration: '30s', target: 30 },
    { duration: '30s', target: 50 },
    { duration: '30s', target: 0 },
  ],

  summaryTrendStats: [
    'avg',
    'min',
    'med',
    'max',
    'p(90)',
    'p(95)',
    'p(99)',
  ],

  thresholds: {
    http_req_duration: ['p(95)<1500'],
    http_req_failed: ['rate<0.05'],
  },

  systemTags: [
    'status',
    'method',
    'url',
    'name',
  ],
};

export default function () {
  group('01 - Login', () => {
    loginTest();
  });

  group('02 - Resident', () => {
    residentTest();
  });

  group('03 - Mutasi', () => {
    mutasiTest();
  });

  group('04 - Report', () => {
    reportTest();
  });

  sleep(1);
}

export function handleSummary(data) {
  return {
    stdout: textSummary(data, {
      indent: ' ',
      enableColors: true,
    }),
    'summary.json': JSON.stringify(data, null, 2),
  };
}

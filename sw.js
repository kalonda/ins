/**
 * Service Worker for Offline Caching
 * Vodafone Foundation Instant Network Schools
 */

const CACHE_NAME = 'vf-ins-v2';
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './css/styles.css',
  './js/sample-data.js',
  './js/db.js',
  './js/i18n.js',
  './js/auth.js',
  './js/supabase.js',
  './js/sync.js',
  './js/components/dashboard.js',
  './js/components/inventory.js',
  './js/components/teaching.js',
  './js/components/teacher-prep.js',
  './js/components/research.js',
  './js/components/community.js',
  './js/components/checkout.js',
  './js/components/incidents.js',
  './js/components/centers.js',
  './js/components/users.js',
  './js/components/reports.js',
  './js/components/settings.js',
  './js/app.js'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Pre-caching offline assets...');
      return cache.addAll(ASSETS_TO_CACHE);
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((name) => {
          if (name !== CACHE_NAME) {
            console.log('Deleting outdated cache:', name);
            return caches.delete(name);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  // Pass non-GET requests or Google API requests through
  if (event.request.method !== 'GET' || event.request.url.includes('script.google.com')) {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }
      return fetch(event.request).then((networkResponse) => {
        if (!networkResponse || networkResponse.status !== 200 || networkResponse.type !== 'basic') {
          return networkResponse;
        }
        const responseToCache = networkResponse.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseToCache);
        });
        return networkResponse;
      }).catch(() => {
        return caches.match('./index.html');
      });
    })
  );
});

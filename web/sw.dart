@JS()
library service_worker_test;

import 'dart:async';

import 'package:sw_wip/service_worker.dart';
import 'package:js/js.dart';

ServiceWorkerGlobalScope sw = new ServiceWorkerGlobalScope();

@JS('self.console.dir')
external dir(o);

@JS('self.console.dir')
external log([a,b,c,d,e,f]);

main(List<String> args) {
  print('Hello from Dart SW.');
  print('Caches: ${sw.caches}');
  _initCache();

  sw.caches.open('x').then((Cache c) {
    print('cache found: $c');
    dir(c);
    c.add('/').then((x) {
      print('cache done $x');
    }).catchError((e) {
      print('cache error $e');
    });
  });

//  sw.onFetch.listen((FetchEvent event) {
//    print('fetch request: ${event.request}');
//    event.respondWith(_getCachedOrFetch(event.request));
//  });

}

//Future<Response> _getCachedOrFetch(Request request) async {
//  Response r = await sw.caches.match(request);
//  if (r != null) {
//    print('Found in cache: ${request.url} $r');
//    return r;
//  }
//  if (r == null) {
//    print('No cached version. Fetching: ${request.url}');
//    r = await sw.fetch(request);
//    print('Got for ${request.url}: ${r}');
//  }
//  return r;
//}

Future _initCache() async {
//  Cache cache = await sw.caches.open('offline-v1');
//  await cache.addAllUrls([
//    '/',
//    '/main.dart',
//    '/main.dart.js',
//    '/styles.css',
//    '/packages/browser/dart.js',
//  ]);
  print('Cache initialized.');
}

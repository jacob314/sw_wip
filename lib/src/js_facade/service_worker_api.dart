@JS()
library service_worker_api;

import "package:js/js.dart";
import "dart:html"
    show
        Worker,
        Event,
        Blob,
        MessagePort,
        MessageEvent,
        ErrorEvent,
        EventTarget;
import "package:func/func.dart";
import "dart:typed_data" show ByteBuffer, Uint8List;

import 'promise.dart';
import 'isomorphic_fetch.dart';

export 'dart:html' show MessageEvent, ErrorEvent;
export 'promise.dart';
export 'isomorphic_fetch.dart';

/// Type definitions for service_worker_api 0.0
/// Project: https://developer.mozilla.org/fr/docs/Web/API/ServiceWorker_API
/// Definitions by: Tristan Caron <https://github.com/tristancaron>
/// Definitions: https://github.com/borisyankov/DefinitelyTyped
/// TypeScript Version: 2.1

/// <reference types="whatwg-fetch" />

/// An CacheOptions object allowing you to set specific control options for the
/// matching done in the match operation.
/// @property [ignoreSearch] A Boolean that specifies whether the matching
/// process should ignore the query string in the url.  If set to true,
/// the ?value=bar part of http://foo.com/?value=bar would be ignored when
/// performing a match. It defaults to false.
/// @property [ignoreMethod] A Boolean that, when set to true, prevents matching
/// operations from validating the Request http method (normally only GET
/// and HEAD are allowed.) It defaults to false.
/// @property [ignoreVary] A Boolean that when set to true tells the matching
/// operation not to perform VARY header matching — i.e. if the URL matches you
/// will get a match regardless of the Response object having a VARY header or
/// not. It defaults to false.
/// @property [cacheName] A DOMString that represents a specific cache to search
/// within. Note that this option is ignored by Cache.match().
@anonymous
@JS()
abstract class CacheOptions {
  external bool get ignoreSearch;
  external set ignoreSearch(bool v);
  external bool get ignoreMethod;
  external set ignoreMethod(bool v);
  external bool get ignoreVary;
  external set ignoreVary(bool v);
  external String get cacheName;
  external set cacheName(String v);
  external factory CacheOptions(
      {bool ignoreSearch,
      bool ignoreMethod,
      bool ignoreVary,
      String cacheName});
}

/// Represents the storage for Request / Response object pairs that are cached as
/// part of the ServiceWorker life cycle.
@anonymous
@JS()
abstract class Cache {
  /// Returns a Promise that resolves to the response associated with the first
  /// matching request in the Cache object.
  external Promise<Response> match(dynamic /*Request|String*/ request,
      [CacheOptions options]);

  /// Returns a Promise that resolves to an array of all matching responses in
  /// the Cache object.
  external Promise<List<Response>> matchAll(dynamic /*Request|String*/ request,
      [CacheOptions options]);

  /// Returns a Promise that resolves to a new Cache entry whose key
  /// is the request.
  external Promise<Null> add(dynamic /*Request|String*/ request);

  /// Returns a Promise that resolves to a new array of Cache entries whose
  /// keys are the requests.
  external Promise<Null> addAll(List<dynamic /*Request|String*/ > requests);

  /// Adds additional key/value pairs to the current Cache object.
  external Promise<Null> put(Request request, Response response);

  /// Finds the Cache entry whose key is the request, and if found, deletes the
  /// Cache entry and returns a Promise that resolves to true. If no Cache
  /// entry is found, it returns false.
  external Promise<bool> delete(dynamic /*Request|String*/ request,
      [CacheOptions options]);

  /// Returns a Promise that resolves to an array of Cache keys.
  external Promise<List<Request>> keys([Request request, CacheOptions options]);
}

/// Represents the storage for Cache objects. It provides a master directory of
/// all the named caches that a ServiceWorker can access and maintains a mapping
/// of string names to corresponding Cache objects.
@anonymous
@JS()
abstract class CacheStorage {
  /// Checks if a given Request is a key in any of the Cache objects that the
  /// CacheStorage object tracks and returns a Promise that resolves
  /// to that match.
  external Promise<Response> match(dynamic /*Request|String*/ request,
      [CacheOptions options]);

  /// Returns a Promise that resolves to true if a Cache object matching
  /// the cacheName exists.
  /// CacheStorage.
  external Promise<bool> has(String cacheName);

  /// Returns a Promise that resolves to the Cache object matching
  /// the cacheName.
  external Promise<Cache> open(String cacheName);

  /// Finds the Cache object matching the cacheName, and if found, deletes the
  /// Cache object and returns a Promise that resolves to true. If no
  /// Cache object is found, it returns false.
  external Promise<bool> delete(String cacheName);

  /// Returns a Promise that will resolve with an array containing strings
  /// corresponding to all of the named Cache objects tracked by the
  /// CacheStorage. Use this method to iterate over a list of all the
  /// Cache objects.
  external Promise<List<String>> keys();
}

/// Represents the scope of a service worker client. A service worker client is
/// either a document in a browser context or a SharedWorker, which is controlled
/// by an active worker.
@anonymous
@JS()
abstract class ServiceWorkerClient {
  /// Allows a service worker client to send a message to a ServiceWorker.
  /// to a port.
  external void postMessage(dynamic message, [dynamic transfer]);

  /// Indicates the type of browsing context of the current client.
  /// This value can be one of auxiliary, top-level, nested, or none.
  external String get frameType;
  external set frameType(String v);

  /// Returns the id of the Client object.
  external String get id;
  external set id(String v);

  /// The URL of the current service worker client.
  external String get url;
  external set url(String v);
}

@anonymous
@JS()
abstract class WindowClient implements ServiceWorkerClient {
  /// Gives user input focus to the current client.
  external Promise<WindowClient> focus();

  /// A boolean that indicates whether the current client has focus.
  external bool get focused;
  external set focused(bool v);

  /// Indicates the visibility of the current client. This value can be one of
  /// hidden, visible, prerender, or unloaded.
  external String get visibilityState;
  external set visibilityState(String v);
}

@anonymous
@JS()
abstract class ServiceWorkerClientsMatchOptions {
  external bool get includeUncontrolled;
  external set includeUncontrolled(bool v);
  external String get type;
  external set type(String v);
  external factory ServiceWorkerClientsMatchOptions(
      {bool includeUncontrolled, String type});
}

/// Represents a container for a list of Client objects; the main way to access
/// the active service worker clients at the current origin.
@anonymous
@JS()
abstract class ServiceWorkerClients {
  /// Gets a service worker client matching a given id and returns it in a Promise.
  external Promise<ServiceWorkerClient> JS$get(String clientId);

  /// Gets a list of service worker clients and returns them in a Promise.
  /// Include the options parameter to return all service worker clients whose
  /// origin is the same as the associated service worker's origin. If options
  /// are not included, the method returns only the service worker clients
  /// controlled by the service worker.
  external Promise<List<ServiceWorkerClient>> matchAll(
      [ServiceWorkerClientsMatchOptions options]);

  /// Opens a service worker Client in a new browser window.
  /// in the window.
  external Promise<WindowClient> openWindow(String url);

  /// Allows an active Service Worker to set itself as the active worker for a
  /// client page when the worker and the page are in the same scope.
  external Promise<Null> claim();
}

/// Represents a service worker. Multiple browsing contexts (e.g. pages, workers,
/// etc.) can be associated with the same ServiceWorker object.
@anonymous
@JS()
abstract class ServiceWorker implements Worker {
  /// Returns the ServiceWorker serialized script URL defined as part of
  /// ServiceWorkerRegistration. The URL must be on the same origin as the
  /// document that registers the ServiceWorker.
  external String get scriptURL;
  external set scriptURL(String v);

  /// Returns the state of the service worker. It returns one of the following
  /// values: installing, installed, activating, activated, or redundant.
  external String get state;
  external set state(String v);

  /// An EventListener property called whenever an event of type statechange
  /// is fired; it is basically fired anytime the ServiceWorker.state changes.
  external VoidFunc1<Event> get onstatechange;
  external set onstatechange(VoidFunc1<Event> v);
}

/// The PushMessageData interface of the Push API provides
/// methods which let you retrieve the push data sent by a server in various formats.
@anonymous
@JS()
abstract class PushMessageData {
  /// Extracts the data as an ArrayBuffer object.
  external ByteBuffer arrayBuffer();

  /// Extracts the data as a Blob object.
  external Blob blob();

  /// Extracts the data as a JSON object.
  /*external dynamic json();*/
  /*external T json<T>();*/
  external dynamic /*dynamic|T*/ json/*<T>*/();

  /// Extracts the data as a plain text string.
  external String text();
}

/// The PushSubscription interface provides a subcription's URL endpoint and
/// subscription ID.
@anonymous
@JS()
abstract class PushSubscription {
  /// The endpoint associated with the push subscription.
  external dynamic get endpoint;
  external set endpoint(dynamic v);

  /// The subscription ID associated with the push subscription.
  external dynamic get subscriptionId;
  external set subscriptionId(dynamic v);
  external factory PushSubscription({dynamic endpoint, dynamic subscriptionId});
}

/// Object containing optional subscribe parameters.
@anonymous
@JS()
abstract class PushSubscriptionOptions {
  /// A boolean indicating that the returned push subscription will only be used for
  /// messages whose effect is made visible to the user.
  external bool get userVisibleOnly;
  external set userVisibleOnly(bool v);

  /// A public key your push server will use to send messages to client apps via a push server.
  /// This value is part of a signing key pair generated by your application server and usable
  /// with elliptic curve digital signature (ECDSA) over the P-256 curve.
  external Uint8List get applicationServerKey;
  external set applicationServerKey(Uint8List v);
  external factory PushSubscriptionOptions(
      {bool userVisibleOnly, Uint8List applicationServerKey});
}

/// The PushManager interface provides a way to receive notifications from
/// third-party servers as well as request URLs for push notifications.
/// This interface has replaced functionality offered by the obsolete
/// PushRegistrationManager.
@anonymous
@JS()
abstract class PushManager {
  /// Returns a promise that resolves to a PushSubscription with details of a
  /// new push subscription.
  external Promise<PushSubscription> subscribe(
      [PushSubscriptionOptions options]);

  /// Returns a promise that resolves to a PushSubscription details of
  /// the retrieved push subscription.
  external Promise<PushSubscription> getSubscription();

  /// Returns a promise that resolves to the PushPermissionStatus of the
  /// requesting webapp, which will be one of granted, denied, or default.
  external Promise<dynamic> hasPermission();
}

/// //// Service Worker Events ///////

/// Extends the lifetime of the install and activate events dispatched on the
/// ServiceWorkerGlobalScope as part of the service worker lifecycle. This
/// ensures that any functional events (like FetchEvent) are not dispatched to
/// the ServiceWorker until it upgrades database schemas, deletes outdated cache
/// entries, etc.
@anonymous
@JS()
abstract class ExtendableEvent implements Event {
  /// Extends the lifetime of the event.
  /// It is intended to be called in the install EventHandler for the
  /// installing worker and on the active EventHandler for the active worker.
  external void waitUntil(Promise<dynamic> promise);
}

/// The parameter passed into the ServiceWorkerGlobalScope.onfetch handler,
/// FetchEvent represents a fetch action that is dispatched on the
/// ServiceWorkerGlobalScope of a ServiceWorker. It contains information about
/// the request and resulting response, and provides the FetchEvent.respondWith()
/// method, which allows us to provide an arbitrary response back to the
/// controlled page.
@anonymous
@JS()
abstract class FetchEvent implements Event {
  /// Returns a Boolean that is true if the event was dispatched with the
  /// user's intention for the page to reload, and false otherwise. Typically,
  /// pressing the refresh button in a browser is a reload, while clicking a
  /// link and pressing the back button is not.
  external bool get isReload;
  external set isReload(bool v);

  /// Returns the Request that triggered the event handler.
  external Request get request;
  external set request(Request v);

  /// Returns the Client that the current service worker is controlling.
  external ServiceWorkerClient get client;
  external set client(ServiceWorkerClient v);

  /// Returns the id of the client that the current service worker is controlling.
  external String get clientId;
  external set clientId(String v);

  /// Resolves by returning a Response or a network error to Fetch.
  external Response respondWith(dynamic all);
}

/// The ExtendableMessageEvent interface of the ServiceWorker API represents
/// the event object of a message event fired on
/// a service worker (when a channel message is received on
/// the ServiceWorkerGlobalScope from another context)
/// — extends the lifetime of such events.
@anonymous
@JS()
abstract class ExtendableMessageEvent implements ExtendableEvent {
  /// Returns the event's data. It can be any data type.
  external dynamic get data;
  external set data(dynamic v);

  /// Returns the origin of the ServiceWorkerClient that sent the message
  external String get origin;
  external set origin(String v);

  /// Represents, in server-sent events, the last event ID of the event source.
  external String get lastEventId;
  external set lastEventId(String v);

  /// Returns a reference to the service worker that sent the message.
  external ServiceWorkerClient get source;
  external set source(ServiceWorkerClient v);

  /// Returns the array containing the MessagePort objects
  /// representing the ports of the associated message channel.
  external List<MessagePort> get ports;
  external set ports(List<MessagePort> v);
}

/// The parameter passed into the oninstall handler, the InstallEvent interface
/// represents an install action that is dispatched on the
/// ServiceWorkerGlobalScope of a ServiceWorker. As a child of ExtendableEvent,
/// it ensures that functional events such as FetchEvent are not dispatched
/// during installation.
@anonymous
@JS()
abstract class InstallEvent implements ExtendableEvent {
  /// Returns the ServiceWorker that is currently actively controlling the page.
  external ServiceWorker get activeWorker;
  external set activeWorker(ServiceWorker v);
}

/// The parameter passed into the onnotificationclick handler,
/// the NotificationEvent interface represents
/// a notification click event that is dispatched on
/// the ServiceWorkerGlobalScope of a ServiceWorker.
@anonymous
@JS()
abstract class NotificationEvent implements ExtendableEvent {
  /// Returns a Notification object representing
  /// the notification that was clicked to fire the event.
  external dynamic get notification;
  external set notification(dynamic v);

  /// Returns the string ID of the notification button the user clicked.
  /// This value returns undefined if the user clicked
  /// the notification somewhere other than an action button,
  /// or the notification does not have a button.
  external String get action;
  external set action(String v);
}

/// The PushEvent interface of the Push API represents
/// a push message that has been received.
/// This event is sent to the global scope of a ServiceWorker.
/// It contains the information sent from an application server to a PushSubscription.
@anonymous
@JS()
abstract class PushEvent implements ExtendableEvent {
  /// Returns a reference to a PushMessageData object containing
  /// data sent to the PushSubscription.
  external PushMessageData get data;
  external set data(PushMessageData v);
}

/// Represents a service worker registration.
@anonymous
@JS()
abstract class ServiceWorkerRegistration implements EventTarget {
  /// Returns a unique identifier for a service worker registration.
  /// This must be on the same origin as the document that registers
  /// the ServiceWorker.
  external dynamic get scope;
  external set scope(dynamic v);

  /// Returns a service worker whose state is installing. This is initially
  /// set to null.
  external ServiceWorker get installing;
  external set installing(ServiceWorker v);

  /// Returns a service worker whose state is installed. This is initially
  /// set to null.
  external ServiceWorker get waiting;
  external set waiting(ServiceWorker v);

  /// Returns a service worker whose state is either activating or activated.
  /// This is initially set to null. An active worker will control a
  /// ServiceWorkerClient if the client's URL falls within the scope of the
  /// registration (the scope option set when ServiceWorkerContainer.register
  /// is first called).
  external ServiceWorker get active;
  external set active(ServiceWorker v);

  /// Returns an interface to for managing push subscriptions, including
  /// subcribing, getting an anctive subscription, and accessing push
  /// permission status.
  external PushManager get pushManager;
  external set pushManager(PushManager v);

  /// An EventListener property called whenever an event of type updatefound
  /// is fired; it is fired any time the ServiceWorkerRegistration.installing
  /// property acquires a new service worker.
  external VoidFunc0 get onupdatefound;
  external set onupdatefound(VoidFunc0 v);

  /// Allows you to update a service worker.
  external void update();

  /// Unregisters the service worker registration and returns a promise
  /// (see Promise). The service worker will finish any ongoing operations
  /// before it is unregistered.
  external Promise<bool> unregister();
}

@anonymous
@JS()
abstract class ServiceWorkerRegisterOptions {
  external String get scope;
  external set scope(String v);
  external factory ServiceWorkerRegisterOptions({String scope});
}

/// Provides an object representing the service worker as an overall unit in the
/// network ecosystem, including facilities to register, unregister and update
/// service workers, and access the state of service workers
/// and their registrations.
@anonymous
@JS()
abstract class ServiceWorkerContainer implements EventTarget {
  /// Returns a ServiceWorker object if its state is activated (the same object
  /// returned by ServiceWorkerRegistration.active). This property returns null
  /// if the request is a force refresh (Shift + refresh) or if there is no
  /// active worker.
  external ServiceWorker get controller;
  external set controller(ServiceWorker v);

  /// Defines whether a service worker is ready to control a page or not.
  /// It returns a Promise that will never reject, which resolves to a
  /// ServiceWorkerRegistration with an ServiceWorkerRegistration.active worker.
  external Promise<ServiceWorkerRegistration> get ready;
  external set ready(Promise<ServiceWorkerRegistration> v);

  /// An event handler fired whenever a controllerchange event occurs — when
  /// the document's associated ServiceWorkerRegistration acquires a new
  /// ServiceWorkerRegistration.active worker.
  external VoidFunc1<Event> get oncontrollerchange;
  external set oncontrollerchange(VoidFunc1<Event> v);

  /// An event handler fired whenever an error event occurs in the associated
  /// service workers.
  external VoidFunc1<ErrorEvent> get onerror;
  external set onerror(VoidFunc1<ErrorEvent> v);

  /// An event handler fired whenever a message event occurs — when incoming
  /// messages are received to the ServiceWorkerContainer object (e.g. via a
  /// MessagePort.postMessage() call.)
  external VoidFunc1<MessageEvent> get onmessage;
  external set onmessage(VoidFunc1<MessageEvent> v);

  /// Creates or updates a ServiceWorkerRegistration for the given scriptURL.
  /// Currently available options are: scope: A USVString representing a URL
  /// that defines a service worker's registration scope; what range of URLs a
  /// service worker can control. This is usually a relative URL, and it
  /// defaults to '/' when not specified.
  external Promise<ServiceWorkerRegistration> register(String scriptURL,
      [ServiceWorkerRegisterOptions options]);

  /// Gets a ServiceWorkerRegistration object whose scope URL matches the
  /// provided document URL.  If the method can't return a
  /// ServiceWorkerRegistration, it returns a Promise.
  /// scope URL of the registration object you want to return. This is usually
  /// a relative URL.
  external Promise<ServiceWorkerRegistration> getRegistration([String scope]);

  /// Returns all ServiceWorkerRegistrations associated with a
  /// ServiceWorkerContainer in an array.  If the method can't return
  /// ServiceWorkerRegistrations, it returns a Promise.
  external Promise<List<ServiceWorkerRegistration>> getRegistrations();
  external addEventListener<K>(String type, listener(K event),
      [bool useCapture]);
}

@anonymous
@JS()
abstract class ServiceWorkerGlobalScope implements EventTarget {
  /// Contains the CacheStorage object associated with the service worker.
  external CacheStorage get caches;
  external set caches(CacheStorage v);

  /// Contains the Clients object associated with the service worker.
  external ServiceWorkerClients get clients;
  external set clients(ServiceWorkerClients v);

  /// Contains the ServiceWorkerRegistration object that represents the
  /// service worker's registration.
  external ServiceWorkerRegistration get registration;
  external set registration(ServiceWorkerRegistration v);

  /// An event handler fired whenever an activate event occurs — when a
  /// ServiceWorkerRegistration acquires a new ServiceWorkerRegistration.active
  /// worker.
  external VoidFunc1<ExtendableEvent> get onactivate;
  external set onactivate(VoidFunc1<ExtendableEvent> v);

  /// An event handler fired whenever a fetch event occurs — when a fetch()
  /// is called.
  external VoidFunc1<FetchEvent> get onfetch;
  external set onfetch(VoidFunc1<FetchEvent> v);

  /// An event handler fired whenever an install event occurs — when a
  /// ServiceWorkerRegistration acquires a new
  /// ServiceWorkerRegistration.installing worker.
  external VoidFunc1<InstallEvent> get oninstall;
  external set oninstall(VoidFunc1<InstallEvent> v);

  /// An event handler fired whenever a message event occurs — when incoming
  /// messages are received. Controlled pages can use the
  /// MessagePort.postMessage() method to send messages to service workers.
  /// The service worker can optionally send a response back via the
  /// MessagePort exposed in event.data.port, corresponding to the controlled
  /// page.
  /// `onmessage` is actually fired with `ExtendableMessageEvent`, but
  /// since we are merging the interface into `Window`, we should
  /// make sure it's compatible with `window.onmessage`
  /// onmessage: (messageevent: ExtendableMessageEvent) => void;
  external VoidFunc1<MessageEvent> get onmessage;
  external set onmessage(VoidFunc1<MessageEvent> v);

  /// An event handler fired whenever a notificationclick event occurs — when
  /// a user clicks on a displayed notification.
  external VoidFunc1<NotificationEvent> get onnotificationclick;
  external set onnotificationclick(VoidFunc1<NotificationEvent> v);

  /// An event handler fired whenever a push event occurs — when a server
  /// push notification is received.
  external VoidFunc1<PushEvent> get onpush;
  external set onpush(VoidFunc1<PushEvent> v);

  /// An event handler fired whenever a pushsubscriptionchange event occurs —
  /// when a push subscription has been invalidated, or is about to be
  /// invalidated (e.g. when a push service sets an expiration time).
  external VoidFunc1<PushEvent> get onpushsubscriptionchange;
  external set onpushsubscriptionchange(VoidFunc1<PushEvent> v);

  /// Allows the current service worker registration to progress from waiting
  /// to active state while service worker clients are using it.
  external Promise<Null> skipWaiting();
  external addEventListener<K>(String type, listener(K event),
      [bool useCapture]);
}

@JS('self')
external ServiceWorkerGlobalScope get globalScope;

/* Skipping class Navigator*/

/// tslint:disable-next-line no-empty-interface

/* Skipping class Window*/

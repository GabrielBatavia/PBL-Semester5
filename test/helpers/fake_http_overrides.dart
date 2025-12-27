// test/helpers/fake_http_overrides.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class FakeRoute {
  final int statusCode;
  final Map<String, String> headers;
  final Uint8List bodyBytes;

  FakeRoute({
    required this.statusCode,
    this.headers = const {},
    Uint8List? bodyBytes,
    String? bodyText,
  }) : bodyBytes = bodyBytes ?? Uint8List.fromList((bodyText ?? '').codeUnits);
}

class FakeHttpOverrides extends HttpOverrides {
  final Map<String, FakeRoute> routes; // key: "POST /path"

  FakeHttpOverrides(this.routes);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient(routes);
  }
}

class _FakeHttpClient implements HttpClient {
  final Map<String, FakeRoute> routes;
  _FakeHttpClient(this.routes);

  Future<HttpClientRequest> _open(String method, Uri url) async {
    return _FakeHttpClientRequest(method.toUpperCase(), url, routes);
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _open(method, url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _open('POST', url);

  @override
  Future<HttpClientRequest> getUrl(Uri url) => _open('GET', url);

  @override
  void close({bool force = false}) {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  final String method;
  final Uri url;
  final Map<String, FakeRoute> routes;

  final HttpHeaders headers = _FakeHttpHeaders();
  final BytesBuilder _buffer = BytesBuilder(copy: false);

  // Properties that `package:http`'s IOClient / MultipartRequest may set/read.
  // If these are missing, Dart will route to noSuchMethod and tests will fail.
  bool _followRedirects = true;
  int _maxRedirects = 5;
  bool _persistentConnection = true;
  bool _bufferOutput = true;
  int _contentLength = -1;
  Encoding _encoding = utf8;

  _FakeHttpClientRequest(this.method, this.url, this.routes);

  String get _key => '$method ${url.path}';

  @override
  void add(List<int> data) => _buffer.add(data);

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final chunk in stream) {
      _buffer.add(chunk);
    }
  }

  @override
  void write(Object? obj) {
    final s = obj?.toString() ?? '';
    _buffer.add(s.codeUnits);
  }

  @override
  Future<HttpClientResponse> close() async {
    final route = routes[_key];
    if (route == null) {
      return _FakeHttpClientResponse(
        statusCode: 500,
        headers: {'content-type': 'text/plain'},
        bodyBytes: Uint8List.fromList('No fake route for $_key'.codeUnits),
      );
    }
    return _FakeHttpClientResponse(
      statusCode: route.statusCode,
      headers: route.headers,
      bodyBytes: route.bodyBytes,
    );
  }

  // ---- HttpClientRequest fields used by IOClient ----
  @override
  bool get followRedirects => _followRedirects;

  @override
  set followRedirects(bool value) => _followRedirects = value;

  @override
  int get maxRedirects => _maxRedirects;

  @override
  set maxRedirects(int value) => _maxRedirects = value;

  @override
  bool get persistentConnection => _persistentConnection;

  @override
  set persistentConnection(bool value) => _persistentConnection = value;

  @override
  bool get bufferOutput => _bufferOutput;

  @override
  set bufferOutput(bool value) => _bufferOutput = value;

  @override
  int get contentLength => _contentLength;

  @override
  set contentLength(int value) => _contentLength = value;

  @override
  Encoding get encoding => _encoding;

  @override
  set encoding(Encoding value) => _encoding = value;

  @override
  Future<HttpClientResponse> get done async => await close();

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {
    // no-op
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // no-op
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    write(objects.join(separator));
  }

  @override
  void writeln([Object? obj = ""]) {
    write("${obj ?? ''}\n");
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _map = {};

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _map.putIfAbsent(name.toLowerCase(), () => []);
    _map[name.toLowerCase()]!.add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _map[name.toLowerCase()] = [value.toString()];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  final int statusCode;
  final Map<String, String> _headers;
  final Uint8List _bodyBytes;

  _FakeHttpClientResponse({
    required this.statusCode,
    required Map<String, String> headers,
    required Uint8List bodyBytes,
  })  : _headers = headers,
        _bodyBytes = bodyBytes;

  @override
  HttpHeaders get headers {
    final h = _FakeHttpHeaders();
    _headers.forEach((k, v) => h.set(k, v));
    return h;
  }

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final controller = StreamController<List<int>>();
    controller.add(_bodyBytes);
    controller.close();
    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

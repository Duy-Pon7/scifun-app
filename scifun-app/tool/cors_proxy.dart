import 'dart:async';
import 'dart:io';

Future<void> main(List<String> args) async {
  final targetBaseUrl = _normalizeBaseUrl(
    Platform.environment['TARGET_BASE_URL'] ??
        'https://java-app-9trd.onrender.com',
  );
  final host = Platform.environment['PROXY_HOST'] ?? '127.0.0.1';
  final port = int.tryParse(Platform.environment['PROXY_PORT'] ?? '') ?? 8787;

  final server = await HttpServer.bind(host, port);
  stdout.writeln('CORS proxy listening at http://$host:$port');
  stdout.writeln('Forwarding to $targetBaseUrl');

  await for (final request in server) {
    unawaited(_handleRequest(request, targetBaseUrl));
  }
}

Future<void> _handleRequest(HttpRequest request, Uri targetBaseUrl) async {
  final origin = request.headers.value('origin') ?? '*';
  _setCorsHeaders(request.response, origin);

  if (request.method.toUpperCase() == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }

  final targetUri = targetBaseUrl.replace(
    path: _joinPath(targetBaseUrl.path, request.uri.path),
    query: request.uri.hasQuery ? request.uri.query : null,
  );

  final client = HttpClient();
  try {
    final upstream = await client.openUrl(request.method, targetUri);
    request.headers.forEach((name, values) {
      final lower = name.toLowerCase();
      if (lower == 'host' ||
          lower == 'origin' ||
          lower == 'referer' ||
          lower == 'content-length') {
        return;
      }
      for (final value in values) {
        upstream.headers.add(name, value);
      }
    });

    final body = await request.fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );
    if (body.isNotEmpty) {
      upstream.add(body);
    }

    final upstreamResponse = await upstream.close();
    request.response.statusCode = upstreamResponse.statusCode;
    upstreamResponse.headers.forEach((name, values) {
      final lower = name.toLowerCase();
      if (lower == 'content-length' ||
          lower == 'transfer-encoding' ||
          lower == 'connection' ||
          lower == 'access-control-allow-origin' ||
          lower == 'access-control-allow-methods' ||
          lower == 'access-control-allow-headers') {
        return;
      }
      for (final value in values) {
        request.response.headers.add(name, value);
      }
    });

    await upstreamResponse.pipe(request.response);
  } catch (e) {
    request.response.statusCode = HttpStatus.badGateway;
    request.response.write('Proxy error: $e');
    await request.response.close();
  } finally {
    client.close(force: true);
  }
}

Uri _normalizeBaseUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError('TARGET_BASE_URL must not be empty.');
  }
  final uri = Uri.parse(trimmed);
  if (!uri.hasScheme || uri.host.isEmpty) {
    throw ArgumentError('TARGET_BASE_URL must be an absolute URL.');
  }
  return uri;
}

String _joinPath(String left, String right) {
  final normalizedLeft =
      left.endsWith('/') ? left.substring(0, left.length - 1) : left;
  final normalizedRight = right.startsWith('/') ? right : '/$right';
  if (normalizedLeft.isEmpty) {
    return normalizedRight;
  }
  return '$normalizedLeft$normalizedRight';
}

void _setCorsHeaders(HttpResponse response, String origin) {
  response.headers.set('Access-Control-Allow-Origin', origin);
  response.headers.set(
    'Access-Control-Allow-Methods',
    'GET, POST, PUT, PATCH, DELETE, OPTIONS',
  );
  response.headers.set(
    'Access-Control-Allow-Headers',
    'Origin, Content-Type, Accept, Authorization, X-TOKEN-ACCESS',
  );
  response.headers.set('Access-Control-Max-Age', '86400');
}

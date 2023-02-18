import 'dart:convert';

import 'package:http/http.dart' as http;

import './event.dart';

abstract class Adapter {
  bool _enabled = true;
  String userAgent = 'Utopia Dart Framework';
  String? clientIP;
  String endpoint = '';

  Adapter(
      {this.userAgent = 'Utopia Dart Framework',
      this.clientIP,
      this.endpoint = ''});

  final Map<String, String> headers = {};
  bool get enabled => _enabled;

  String getName();
  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
  }

  Future<bool> send(Event event);
  Future<bool> validate(Event event);
  Future<bool> createEvent(Event event) async {
    try {
      return await send(event);
    } on Exception catch (e) {
      logError(e);
      return false;
    }
  }

  dynamic call({
    required String method,
    String path = '',
    Map<String, String> headers = const {},
    Map<String, dynamic> params = const {},
  }) async {
    late http.Response res;
    Uri uri = Uri.parse(endpoint + path);
    http.BaseRequest request = http.Request(method, uri);
    if (headers['content-type'] == 'multipart/form-data') {
      request = http.MultipartRequest(method, uri);
      if (params.isNotEmpty) {
        params.forEach((key, value) {
          if (value is http.MultipartFile) {
            (request as http.MultipartRequest).files.add(value);
          } else {
            if (value is List) {
              value.asMap().forEach((i, v) {
                (request as http.MultipartRequest)
                    .fields
                    .addAll({"$key[$i]": v.toString()});
              });
            } else {
              (request as http.MultipartRequest)
                  .fields
                  .addAll({key: value.toString()});
            }
          }
        });
      }
    } else if (method.toLowerCase() == 'get') {
      if (params.isNotEmpty) {
        params = params.map((key, value) {
          if (value is int || value is double) {
            return MapEntry(key, value.toString());
          }
          if (value is List) {
            return MapEntry("$key[]", value);
          }
          return MapEntry(key, value);
        });
      }
      uri = Uri(
          fragment: uri.fragment,
          path: uri.path,
          host: uri.host,
          scheme: uri.scheme,
          queryParameters: params,
          port: uri.port);
      request = http.Request(method, uri);
    } else {
      (request as http.Request).body = jsonEncode(params);
    }
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    res = await http.Response.fromStream(streamedResponse);

    if (res.headers['content-type']?.contains('application/json') ?? false) {
      return jsonDecode(res.body);
    }
    return res.body;
  }

  void logError(Exception e) {
    print(e.toString());
  }
}

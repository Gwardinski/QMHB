import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:qmhb/shared/exceptions/exceptions.dart';

class HttpService {
  Future<ServiceResponse> get(
    Uri uri, {
    Map<String, String> headers,
  }) async {
    final response = await http.get(
      uri,
      headers: headers ?? _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> post(
    Uri uri, {
    dynamic body,
    Map<String, String> headers,
  }) async {
    final response = await http.post(
      uri,
      headers: headers ?? _getHeaders(),
      body: body,
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> put(
    Uri uri, {
    dynamic body,
    Map<String, String> headers,
  }) async {
    final response = await http.put(
      uri,
      body: body,
      headers: headers ?? _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> delete(
    Uri uri, {
    Map<String, String> headers,
  }) async {
    final response = await http.delete(
      uri,
      headers: headers,
    );
    return _handleResponse(response);
  }

  Map<String, String> _getHeaders() {
    return {
      "Accept": "application/json",
      "content-type": "application/json",
    };
  }

  ServiceResponse _handleResponse(http.Response response) {
    if (response.statusCode >= 200 || response.statusCode < 300) {
      if (response.body != null && response.body.length > 0) {
        return ServiceResponse.fromJson(
          jsonDecode(response.body),
        );
      }
      return ServiceResponse.fromJson("");
    } else {
      switch (response.statusCode) {
        case 400:
          throw Http400Exception(response);
        case 401:
          throw Http403Exception(response);
        case 403:
          throw Http403Exception(response);
        case 404:
          throw Http404Exception(response);
        case 409:
          throw Http409Exception(response);
        case 500:
          throw Http500Exception(response);
        default:
          throw UnknownException(response);
      }
    }
  }
}

class ServiceResponse {
  // int code;
  // String message;
  dynamic data;

  ServiceResponse.fromJson(json) {
    // code = json["code"];
    // message = json["message"];
    data = json;
  }
}

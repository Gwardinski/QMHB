import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart' as ioclient;
import 'package:qmhb/shared/exceptions/exceptions.dart';

class HttpService {
  var _ioClient;

  HttpService() {
    var _httpClient = HttpClient();
    _httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    _ioClient = ioclient.IOClient(_httpClient);
  }

  Future<ServiceResponse> get(
    String url, {
    Map<String, String> headers,
  }) async {
    final response = await _ioClient.get(
      url,
      headers: headers ?? _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> post(
    String url, {
    dynamic body,
    Map<String, String> headers,
  }) async {
    final response = await _ioClient.post(
      url,
      headers: headers ?? _getHeaders(),
      body: body,
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> put(
    String url, {
    dynamic body,
    Map<String, String> headers,
  }) async {
    final response = await _ioClient.put(
      url,
      body: body,
      headers: headers ?? _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<ServiceResponse> delete(
    String url, {
    Map<String, String> headers,
  }) async {
    final response = await _ioClient.delete(
      url,
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
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return ServiceResponse.fromJson(
        jsonDecode(response.body),
      );
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
  int code;
  String message;
  dynamic data;

  ServiceResponse.fromJson(json) {
    code = json["code"];
    message = json["message"];
    data = json["data"];
  }
}

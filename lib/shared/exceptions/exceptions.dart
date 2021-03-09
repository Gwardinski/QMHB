import 'package:http/http.dart' as http;

class BaseException implements Exception {
  BaseException(this.message);

  String message = '';

  @override
  String toString() => message;
}

class Http400Exception extends BaseException {
  Http400Exception(http.Response response) : super(response.body);
}

class Http403Exception extends BaseException {
  Http403Exception(http.Response response) : super(response.body);
}

class Http404Exception extends BaseException {
  Http404Exception(http.Response response) : super(response.body);
}

class Http409Exception extends BaseException {
  Http409Exception(http.Response response) : super(response.body);
}

class Http500Exception extends BaseException {
  Http500Exception(http.Response response) : super(response.body);
}

class UnknownException extends BaseException {
  UnknownException(http.Response response) : super(response.body);
}

//400
class BadRequestException extends BaseException {
  BadRequestException() : super('Bad request');
}

//403
class InvalidTokenException extends BaseException {
  InvalidTokenException() : super('Invalid auth Token');
}

//403
class NotFoundException extends BaseException {
  NotFoundException() : super('Not found');
}

//409
class ConflictException extends BaseException {
  ConflictException() : super('Conflict');
}

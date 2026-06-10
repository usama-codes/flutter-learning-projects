import 'dart:convert';

import 'package:http/http.dart' as http;

import 'resource.dart';

class HttpCrudApiException implements Exception {
  final String message;

  const HttpCrudApiException(this.message);

  @override
  String toString() => message;
}

class HttpCrudApi {
  static const String host = 'dummyjson.com';
  static const String usersPath = '/users';
  static const String usersCollectionUrl = 'https://dummyjson.com/users';
  static const Duration requestTimeout = Duration(seconds: 15);

  Uri get _usersUri => Uri.https(host, usersPath);

  Uri _userUri(int id) => Uri.https(host, '$usersPath/$id');

  Uri _addUserUri() => Uri.https(host, '$usersPath/add');

  Map<String, String> _jsonHeaders() {
    return const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Resource>> fetchUsers() async {
    final response = await http.get(_usersUri).timeout(requestTimeout);
    final payload = _decodeObject(
      response,
      expectedStatuses: const {200},
      action: 'load users',
    );

    final users = payload['users'];
    if (users is! List) {
      throw const HttpCrudApiException('Unexpected users payload shape.');
    }

    return users
        .whereType<Map<String, dynamic>>()
        .map(Resource.fromJson)
        .toList(growable: false);
  }

  Future<Resource> fetchUser(int id) async {
    final response = await http.get(_userUri(id)).timeout(requestTimeout);
    final payload = _decodeObject(
      response,
      expectedStatuses: const {200},
      action: 'load user',
    );
    return Resource.fromJson(payload);
  }

  Future<Resource> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final response = await http
        .post(
          _addUserUri(),
          headers: _jsonHeaders(),
          body: jsonEncode({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
          }),
        )
        .timeout(requestTimeout);

    final payload = _decodeObject(
      response,
      expectedStatuses: const {200, 201},
      action: 'create user',
    );
    return Resource.fromJson(payload);
  }

  Future<Resource> putUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return _updateUser(
      method: 'PUT',
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<Resource> patchUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return _updateUser(
      method: 'PATCH',
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(_userUri(id)).timeout(requestTimeout);
    _ensureSuccess(
      response,
      expectedStatuses: const {200, 202, 204},
      action: 'delete user',
    );
  }

  Future<Resource> _updateUser({
    required String method,
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final uri = _userUri(id);
    final response = switch (method) {
      'PUT' =>
        await http
            .put(
              uri,
              headers: _jsonHeaders(),
              body: jsonEncode({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
              }),
            )
            .timeout(requestTimeout),
      'PATCH' =>
        await http
            .patch(
              uri,
              headers: _jsonHeaders(),
              body: jsonEncode({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
              }),
            )
            .timeout(requestTimeout),
      _ => throw ArgumentError.value(method, 'method', 'Unsupported method'),
    };

    final payload = _decodeObject(
      response,
      expectedStatuses: const {200},
      action: '${method.toLowerCase()} user',
    );
    return Resource.fromJson(payload);
  }

  Map<String, dynamic> _decodeObject(
    http.Response response, {
    required Set<int> expectedStatuses,
    required String action,
  }) {
    _ensureSuccess(
      response,
      expectedStatuses: expectedStatuses,
      action: action,
    );

    final body = response.body.trim();
    if (body.isEmpty) {
      throw HttpCrudApiException('Empty response while trying to $action.');
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw HttpCrudApiException(
      'Expected a JSON object while trying to $action.',
    );
  }

  void _ensureSuccess(
    http.Response response, {
    required Set<int> expectedStatuses,
    required String action,
  }) {
    if (expectedStatuses.contains(response.statusCode)) {
      return;
    }

    final body = response.body.trim();
    final baseMessage = 'HTTP ${response.statusCode} while trying to $action.';
    throw HttpCrudApiException(
      body.isEmpty ? baseMessage : '$baseMessage\n\n$body',
    );
  }
}

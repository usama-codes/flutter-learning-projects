import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiClient {
  static late ApiClient instance;

  final String baseUrl;
  final Duration requestTimeout;

  int currentPage = 1;
  int pageSize = 10;
  static late int totalItems;
  static const Map<String, String> _defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  ApiClient({
    required this.baseUrl,
    this.requestTimeout = const Duration(seconds: 15),
  });

  Uri _buildUri(String endpoint) {
    final clean = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$clean');
  }

  dynamic _handleResponse(
    http.Response response, {
    required Set<int> expectedStatuses,
    required String action,
  }) {
    if (!expectedStatuses.contains(response.statusCode)) {
      throw ApiException(
        'Failed to $action. Status code: ${response.statusCode}, Body: ${response.body}',
        statusCode: response.statusCode,
      );
    }
    if (response.body.isEmpty) return null;
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body['total'] != null) {
        totalItems = body['total'] as int;
      }
      return body;
    } catch (e) {
      throw ApiException(
        'Failed to parse response for $action. Body: ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  Future<T> get<T>({
    required String endpoint,
    required T Function(dynamic) fromJson,
    String? dataKey,
    Map<String, String>? queryParams,
  }) async {
    final qpLocal = <String, String>{};
    if (queryParams != null) qpLocal.addAll(queryParams);
    if (!qpLocal.containsKey('page')) qpLocal['page'] = currentPage.toString();
    if (!qpLocal.containsKey('pageSize')) {
      qpLocal['pageSize'] = pageSize.toString();
    }
    final uri = _buildUri(endpoint).replace(queryParameters: qpLocal);
    try {
      // debugPrint('REQUEST GET $uri');
      final response = await http
          .get(uri, headers: _defaultHeaders)
          .timeout(
            requestTimeout,
            onTimeout: () => throw ApiException('Request timeout'),
          );
      debugPrint('RESPONSE ${response.statusCode}: ${response.body}');

      final decoded = _handleResponse(
        response,
        expectedStatuses: {200},
        action: 'get',
      );

      List<dynamic> dataList;
      if (decoded is List) {
        dataList = decoded;
      } else if (decoded is Map<String, dynamic>) {
        final key = dataKey ?? 'data';
        if (decoded.containsKey(key) && decoded[key] is List) {
          dataList = decoded[key] as List;
        } else if (decoded.containsKey('results') &&
            decoded['results'] is List) {
          dataList = decoded['results'] as List;
        } else if (decoded.containsKey('items') && decoded['items'] is List) {
          dataList = decoded['items'] as List;
        } else {
          throw ApiException(
            'Could not find data array. Keys: ${decoded.keys.join(', ')}',
          );
        }
      } else {
        throw ApiException(
          'Unexpected response format: ${decoded.runtimeType}',
        );
      }

      return fromJson(dataList);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching resource: $e');
    }
  }

  Future<T> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = _buildUri(endpoint);
    try {
      final response = await http
          .post(uri, headers: _defaultHeaders, body: jsonEncode(body))
          .timeout(
            requestTimeout,
            onTimeout: () => throw ApiException('Request timeout'),
          );
      debugPrint('RESPONSE ${response.statusCode}: ${response.body}');
      final decoded = _handleResponse(
        response,
        expectedStatuses: {200, 201},
        action: 'post',
      );
      return fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error posting resource: $e');
    }
  }

  Future<T> patch<T>({
    required String endpoint,
    required dynamic id,
    required Map<String, dynamic> changes,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = _buildUri('$endpoint/$id');
    try {
      final response = await http
          .patch(uri, headers: _defaultHeaders, body: jsonEncode(changes))
          .timeout(
            requestTimeout,
            onTimeout: () => throw ApiException('Request timeout'),
          );
      debugPrint('RESPONSE ${response.statusCode}: ${response.body}');
      final decoded = _handleResponse(
        response,
        expectedStatuses: {200},
        action: 'patch',
      );
      return fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error patching resource: $e');
    }
  }

  Future<bool> delete({required String endpoint, required dynamic id}) async {
    final uri = _buildUri('$endpoint/$id');
    try {
      final response = await http
          .delete(uri, headers: _defaultHeaders)
          .timeout(
            requestTimeout,
            onTimeout: () => throw ApiException('Request timeout'),
          );
      debugPrint('RESPONSE ${response.statusCode}: ${response.body}');
      _handleResponse(response, expectedStatuses: {200, 204}, action: 'delete');
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return false;
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting resource: $e');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/role.dart';

class RoleServiceException implements Exception {
  final String message;
  const RoleServiceException(this.message);

  @override
  String toString() => message;
}

class RoleService {
  static const String _baseUrl = 'https://api.wraeglobal.com/roleRouter';
  static const Duration _timeout = Duration(seconds: 60);

  final http.Client _client;

  RoleService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      throw const RoleServiceException('No internet connection. Please check your network.');
    }
  }

  Future<List<Role>> fetchActiveRoles() => _fetchRolesWithRetry('$_baseUrl/getActiveRoles');
  Future<List<Role>> fetchArchivedRoles() => _fetchRolesWithRetry('$_baseUrl/getArchivedRoles');

  Future<List<Role>> _fetchRolesWithRetry(String url, {int retries = 2}) async {
    int attempts = 0;
    while (attempts < retries) {
      try {
        return await _fetchRoles(url);
      } on TimeoutException {
        attempts++;
        if (attempts >= retries) rethrow;
        await Future.delayed(const Duration(seconds: 2)); // Wait before retry
      } catch (e) {
        rethrow;
      }
    }
    throw const RoleServiceException('Maximum retries exceeded');
  }

  Future<List<Role>> _fetchRoles(String url) async {
    await _checkConnectivity();

    try {
      final response = await _client.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode != 200) {
        throw RoleServiceException('Server error (${response.statusCode}). Please try again later.');
      }

      final body = json.decode(response.body) as Map<String, dynamic>;

      if (!body.containsKey('roles')) {
        return [];
      }

      final rawList = body['roles'];
      if (rawList == null || rawList is! List) return [];

      return rawList
          .whereType<Map<String, dynamic>>()
          .map(Role.fromJson)
          .toList();
    } on SocketException {
      throw const RoleServiceException('Network unreachable. Please try again.');
    } on TimeoutException {
      throw const RoleServiceException('Request timed out. Please try again.');
    } catch (e) {
      throw RoleServiceException('An unexpected error occurred: $e');
    }
  }
}

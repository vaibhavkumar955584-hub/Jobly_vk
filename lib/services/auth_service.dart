import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'https://api.wraeglobal.com/auth'; // Hypothetical
  final _storage = const FlutterSecureStorage();

  Future<String?> get token async => await _storage.read(key: 'jwt_token');

  Future<User?> login(String email, String password) async {
    // Design: POST /auth/login { email, password }
    // Since there's no real endpoint, we simulate it
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == "demo@jobly.com" && password == "password123") {
      final mockUser = User(id: '1', email: email, name: 'Jobly Demo User');
      await _storage.write(key: 'jwt_token', value: 'mock_jwt_token_header.payload.signature');
      await _storage.write(key: 'user_data', value: jsonEncode(mockUser.toJson()));
      return mockUser;
    }
    throw Exception('Invalid email or password');
  }

  Future<User?> signup(String name, String email, String password) async {
    // Design: POST /auth/signup { name, email, password }
    await Future.delayed(const Duration(seconds: 1));
    final mockUser = User(id: '2', email: email, name: name);
    await _storage.write(key: 'jwt_token', value: 'mock_jwt_token_signup');
    await _storage.write(key: 'user_data', value: jsonEncode(mockUser.toJson()));
    return mockUser;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<User?> getCurrentUser() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await _service.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _service.login(email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _service.signup(name, email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String bio) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      if (_user != null) {
        _user = User(
          id: _user!.id,
          email: _user!.email,
          name: name,
          bio: bio,
          profileImageUrl: _user!.profileImageUrl,
          resumeUrl: _user!.resumeUrl,
          phoneNumber: _user!.phoneNumber,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

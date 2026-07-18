import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/role.dart';
import '../services/role_service.dart';

class RoleProvider extends ChangeNotifier {
  final RoleService _service = RoleService();
  
  List<Role> _activeRoles = [];
  List<Role> _archivedRoles = [];
  Set<int> _savedRoleIds = {};
  
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  List<Role> get activeRoles => _activeRoles;
  List<Role> get archivedRoles => _archivedRoles;
  Set<int> get savedRoleIds => _savedRoleIds;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  RoleProvider() {
    _loadSavedRoles();
  }

  Future<void> _loadSavedRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_roles') ?? [];
    _savedRoleIds = saved.map(int.parse).toSet();
    notifyListeners();
  }

  Future<void> toggleSaveRole(int roleId) async {
    if (_savedRoleIds.contains(roleId)) {
      _savedRoleIds.remove(roleId);
    } else {
      _savedRoleIds.add(roleId);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_roles', _savedRoleIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  bool isSaved(int roleId) => _savedRoleIds.contains(roleId);

  Future<void> fetchRoles({bool active = true, bool loadMore = false}) async {
    if (loadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
    }
    _error = null;
    notifyListeners();

    try {
      final newRoles = active
          ? await _service.fetchActiveRoles()
          : await _service.fetchArchivedRoles();
      
      if (loadMore) {
        if (active) {
          _activeRoles.addAll(newRoles);
        } else {
          _archivedRoles.addAll(newRoles);
        }
        _hasMore = false; // Simulated: stop after 1st load more
      } else {
        if (active) {
          _activeRoles = newRoles;
        } else {
          _archivedRoles = newRoles;
        }
        _hasMore = true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> applyToRole(int roleId) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; 
  }
}

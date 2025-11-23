import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';

class PasswordService {
  final _storage = const FlutterSecureStorage();
  static const String _passwordPrefix = 'password_';

  Future<List<PasswordModel>> getAllPasswords() async {
    try {
      final allKeys = await _storage.readAll();
      final passwordKeys = allKeys.keys.where((key) => key.startsWith(_passwordPrefix));

      final List<PasswordModel> passwords = [];

      for (var key in passwordKeys) {
        final value = allKeys[key];
        if (value != null) {
          final jsonData = jsonDecode(value);
          passwords.add(PasswordModel.fromJson(jsonData, key));
        }
      }

      // Ordenar por data de criação (mais recente primeiro)
      passwords.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return passwords;
    } catch (e) {
      // Error loading passwords
      return [];
    }
  }

  Future<void> savePassword(PasswordModel password) async {
    try {
      final jsonData = jsonEncode(password.toJson());
      await _storage.write(key: password.id, value: jsonData);
    } catch (e) {
      // Error saving password
      rethrow;
    }
  }

  Future<void> deletePassword(String id) async {
    try {
      await _storage.delete(key: id);
    } catch (e) {
      // Error deleting password
      rethrow;
    }
  }

  Future<PasswordModel?> getPasswordById(String id) async {
    try {
      final value = await _storage.read(key: id);
      if (value != null) {
        final jsonData = jsonDecode(value);
        return PasswordModel.fromJson(jsonData, id);
      }
      return null;
    } catch (e) {
      // Error getting password
      return null;
    }
  }

  Future<List<PasswordModel>> getPasswordsByCategory(String category) async {
    final allPasswords = await getAllPasswords();
    return allPasswords.where((p) => p.category == category).toList();
  }

  Future<List<PasswordModel>> searchPasswords(String query) async {
    final allPasswords = await getAllPasswords();
    final lowerQuery = query.toLowerCase();
    return allPasswords.where((p) =>
        p.title.toLowerCase().contains(lowerQuery) ||
        p.username.toLowerCase().contains(lowerQuery) ||
        p.website.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

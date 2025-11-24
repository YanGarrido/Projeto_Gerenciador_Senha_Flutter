import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';

class PasswordService {
  final _storage = const FlutterSecureStorage();
  static const String _passwordPrefix = 'password_';
  static const String _metadataKey = 'passwords_metadata';

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

     
      passwords.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return passwords;
    } catch (e) {
      
      return [];
    }
  }

  Future<void> savePassword(PasswordModel password) async {
    try {
      final jsonData = jsonEncode(password.toJson());
      await _storage.write(key: password.id, value: jsonData);
      await _updateMetadata();
    } catch (e) {
      
      rethrow;
    }
  }

  Future<void> _updateMetadata() async {
    try {
      final allPasswords = await getAllPasswords();
      final metadata = {
        'total_count': allPasswords.length,
        'last_updated': DateTime.now().toIso8601String(),
        'categories': _getCategories(allPasswords),
      };
      await _storage.write(key: _metadataKey, value: jsonEncode(metadata));
    } catch (e) {
    
    }
  }

  Map<String, int> _getCategories(List<PasswordModel> passwords) {
    final categories = <String, int>{};
    for (var password in passwords) {
      categories[password.category] = (categories[password.category] ?? 0) + 1;
    }
    return categories;
  }

  Future<Map<String, dynamic>?> getMetadata() async {
    try {
      final value = await _storage.read(key: _metadataKey);
      if (value != null) {
        return jsonDecode(value) as Map<String, dynamic>;
      }
    } catch (e) {
     
    }
    return null;
  }

  Future<void> deletePassword(String id) async {
    try {
      await _storage.delete(key: id);
      await _updateMetadata();
    } catch (e) {
     
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

  
  Future<String> exportPasswords() async {
    try {
      final allPasswords = await getAllPasswords();
      final exportData = {
        'version': '1.0',
        'exported_at': DateTime.now().toIso8601String(),
        'passwords': allPasswords.map((p) => {
          'id': p.id,
          ...p.toJson(),
        }).toList(),
      };
      return jsonEncode(exportData);
    } catch (e) {
      rethrow;
    }
  }

  
  Future<int> importPasswords(String jsonString, {bool overwrite = false}) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final passwordsList = data['passwords'] as List<dynamic>;
      
      int importedCount = 0;
      
      for (var passwordData in passwordsList) {
        final id = passwordData['id'] as String;
        
        
        if (!overwrite) {
          final existing = await getPasswordById(id);
          if (existing != null) {
            continue; 
          }
        }
        
        final password = PasswordModel.fromJson(passwordData as Map<String, dynamic>, id);
        await savePassword(password);
        importedCount++;
      }
      
      return importedCount;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> clearAllPasswords() async {
    try {
      final allKeys = await _storage.readAll();
      final passwordKeys = allKeys.keys.where((key) => key.startsWith(_passwordPrefix));
      
      for (var key in passwordKeys) {
        await _storage.delete(key: key);
      }
      
      await _storage.delete(key: _metadataKey);
    } catch (e) {
      rethrow;
    }
  }

 
  Future<bool> isStorageAvailable() async {
    try {
      await _storage.write(key: 'test_key', value: 'test_value');
      final value = await _storage.read(key: 'test_key');
      await _storage.delete(key: 'test_key');
      return value == 'test_value';
    } catch (e) {
      return false;
    }
  }
}

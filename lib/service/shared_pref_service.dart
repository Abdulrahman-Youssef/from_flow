import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Singleton
  SharedPrefService._internal();
  static final SharedPrefService _instance = SharedPrefService._internal();
  factory SharedPrefService() => _instance;

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call once on app start)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save a string
  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save a boolean
  Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get a boolean
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Save a JSON object
  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await _prefs?.setString(key, jsonString);
  }

  /// Get a JSON object
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all data
  Future<void> clear() async {
    await _prefs?.clear();
  }
}

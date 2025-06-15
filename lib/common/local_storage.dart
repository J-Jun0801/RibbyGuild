import 'package:shared_preferences/shared_preferences.dart';

/// Repository 레벨의 로컬 스토리지 구현
class MyLocalStorage {
  MyLocalStorage();

  late final SharedPreferences _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Object? get(String key) => _preferences.get(key);

  @override
  double? getDouble(String key) => _preferences.getDouble(key);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  Set<String> getKeys() => _preferences.getKeys();

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  @override
  Future<bool> setBool(String key, bool value) => _preferences.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _preferences.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) => _preferences.setString(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) => _preferences.setStringList(key, value);
}

const keyId = "id";

import 'dart:html';

class SessionStorage {
  static final SessionStorage _instance = SessionStorage._internal();

  final Storage _localStorage = window.sessionStorage;

  factory SessionStorage() {
    return _instance;
  }

  SessionStorage._internal();

  Future setString(String id, String value) async => _localStorage[id] = value;

  Future<String?> getString(String id) async => _localStorage[id];

  Future setInt(String id, int value) async => _localStorage[id] = value.toString();

  Future<int?> getInt(String id) async => _localStorage[id] == null ? null : int.parse(_localStorage[id]!);

  Future setBool(String id, bool value) async => _localStorage[id] = value.toString();

  Future<bool?> getBool(String id) async => _localStorage[id] == null ? null : _localStorage[id]!.toLowerCase() == 'true';

}

import 'package:flutter/foundation.dart';
import '../util/web_util/web_dummy_class.dart' if (dart.library.js) 'dart:html' as html;
// import 'dart:html' as html;

class SessionStorage {
  static final SessionStorage _instance = SessionStorage._internal();

  final html.Storage _localStorage = html.window.sessionStorage;

  factory SessionStorage() {
    return _instance;
  }

  SessionStorage._internal();

  Future setString(String id, String value) async {
    if (!kIsWeb) return;
    return _localStorage[id] = value;
  }

  Future<String?> getString(String id) async {
    if (!kIsWeb) return null;
    return _localStorage[id];
  }

  Future setInt(String id, int value) async {
    if (!kIsWeb) return;
    return _localStorage[id] = value.toString();
  }

  Future<int?> getInt(String id) async {
    if (!kIsWeb) return null;
    return _localStorage[id] == null ? null : int.parse(_localStorage[id]!);
  }

  Future setBool(String id, bool value) async {
    if (!kIsWeb) return;
    return _localStorage[id] = value.toString();
  }

  Future<bool?> getBool(String id) async {
    if (!kIsWeb) return null;
    return _localStorage[id] == null ? null : _localStorage[id]!.toLowerCase() == 'true';
  }
}

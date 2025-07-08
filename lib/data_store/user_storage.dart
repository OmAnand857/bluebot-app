import 'package:hive/hive.dart';

class UserStorage {
  static final Box _box = Hive.box('userBox');

  static Future<void> saveUserSession({required String userName}) async {
    await _box.put('user_session', {'user_name': userName});
  }

  static Map<String, dynamic>? getUserSession() {
    final data = _box.get('user_session');
    return (data != null && data is Map)
        ? Map<String, dynamic>.from(data)
        : null;
  }

  static String? getUserName() {
    final session = getUserSession();
    return session?['user_name'];
  }

  static Future<void> clearSession() async {
    await _box.delete('user_session');
  }
}

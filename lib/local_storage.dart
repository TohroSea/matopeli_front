import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const _key = 'local_highscores';

  static Future<List<Map<String, dynamic>>> getLocalHighscores() async {
    final prefs = await SharedPreferences.getInstance();
    final highscoresJson = prefs.getString(_key);
    if (highscoresJson != null) {
      final List<dynamic> highscoresList = await jsonDecode(highscoresJson);
      return highscoresList.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  static Future<void> saveLocalHighscores(List<Map<String, dynamic>> highscores) async {
    final prefs = await SharedPreferences.getInstance();
    final highscoresJson = jsonEncode(highscores);
    await prefs.setString(_key, highscoresJson);
  }
}
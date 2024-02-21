import 'dart:convert';
import 'dart:io';

class HighscoreEntry {
  final String name;
  final DateTime date;
  final int score;

  HighscoreEntry({
    required this.name, 
    required this.date, 
    required this.score
    });
}

class LocalHighscoreManager {
  static const String _fileName = 'local_highscores.json';

  static Future<List<HighscoreEntry>> loadLocalHighscores() async {
    try {
      final file = File(_fileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((entry) {
          return HighscoreEntry(
            name: entry['name'],
            date: DateTime.parse(entry['date']),
            score: entry['score'],
          );
        }).toList();
      }
      print('Local scores loaded succesfully');
    } catch (e) {
      print('Error loading local highscores: $e');
    }
    return [];
  }

  static Future<void> saveLocalHighscores(List<HighscoreEntry> highscores) async {
    try {
      final file = File(_fileName);
      final jsonString = jsonEncode(
        highscores
            .map((entry) => {
                  'name': entry.name,
                  'date': entry.date.toIso8601String(),
                  'score': entry.score,
                })
            .toList(),
      );
      await file.writeAsString(jsonString);
      print('Saved to local JSON');
    } catch (e) {
      print('Error saving local highscores: $e');
    }
  }
}
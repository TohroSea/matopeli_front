import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> pushHighscore(String username, int pisteet) async {
  const String apiUrl = 'https://matopeli-jkth.azurewebsites.net/api/submit';
  Map<String,String> headers = {
    'Content-type' : 'application/json', 
    'Accept': 'application/json',
  };
  final vastaus = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: jsonEncode({'name': username, 'points': pisteet}),
  );

  if (vastaus.statusCode == 200) {
    print("Pisteiden lähetys onnistui");
  }
  else {
    print("Jokin meni vikaan lähettäessä pisteitä.");
  }
}

Future<List<Map<String, dynamic>>> fetchHighscores() async {
  final cloudResponse = await http.get(Uri.parse('https://matopeli-jkth.azurewebsites.net/api/highscores'));
  if (cloudResponse.statusCode == 200) {
    return jsonDecode(cloudResponse.body).cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load cloud highscores');
  }
}
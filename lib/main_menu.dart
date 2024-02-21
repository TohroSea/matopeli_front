import 'package:flutter/material.dart';
import 'highscores_screen.dart';
import 'main.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SNAKE',
              style: TextStyle(
                color: Colors.green,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SnakeGame()),
                );
              },
              child: const Text('PLAY'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HighscoresScreen()),
                );
              },
              child: const Text('HIGHSCORES'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'local_storage.dart'; 
import 'push_and_fetch_score.dart';

class HighscoresScreen extends StatefulWidget {
  const HighscoresScreen({Key? key}) : super(key: key);

  @override
  _HighscoresScreenState createState() => _HighscoresScreenState();
}

class _HighscoresScreenState extends State<HighscoresScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> localHighscores = [];
  List<Map<String, dynamic>> cloudHighscores = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchHighscores(); // Fetch highscores when the widget initializes
    _fetchLocalHighscores(); // Fetch local highscores
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocalHighscores() async {
  final localHighscores = await LocalStorage.getLocalHighscores();
  setState(() {
    this.localHighscores = localHighscores;
  });
}

  Future<void> _fetchHighscores() async {
    try {
      final highscores = await fetchHighscores();
      setState(() {
        cloudHighscores = highscores;
      });
    } catch (e) {
      print('Error fetching highscores: $e');
      // Handle error, show error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highscores'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiped to the right
            if (_tabController.index > 0) {
              _tabController.animateTo(_tabController.index - 1);
            }
          } else if (details.primaryVelocity! < 0) {
            // Swiped to the left
            if (_tabController.index < _tabController.length - 1) {
              _tabController.animateTo(_tabController.index + 1);
            }
          }
        },
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Local Scores'),
                Tab(text: 'Cloud Scores'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Content for Local Scores tab
                  localHighscores.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: localHighscores.length,
                          itemBuilder: (context, index) {
                            final highscore = localHighscores[index];
                            return ListTile(
                              leading: Text((index + 1).toString()), // Index number
                              title: Text(highscore['name'].toString()), // Username
                              trailing: Text(highscore['score'].toString()), // Score
                            );
                          },
                        ),
                  // Content for Cloud Scores tab
                  cloudHighscores.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: cloudHighscores.length,
                          itemBuilder: (context, index) {
                            final highscore = cloudHighscores[index];
                            return ListTile(
                              leading: Text((index + 1).toString()), // Index number
                              title: Text(highscore['name'].toString()), // Username
                              trailing: Text(highscore['points'].toString()), // Score
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

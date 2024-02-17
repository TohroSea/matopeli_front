import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGameApp());
}

// This class epresents the entire application
class SnakeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp widget, that provides app structure and theme.
      home: MainMenu(),
    );
  }
}
class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            'SNAKE',
            style: TextStyle(
              color: Colors.green,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakeGame()),
                );
              },
              child: Text('PLAY'),
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
               onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HighscoresScreen()),
                );
              },
              child: Text('HIGHSCORES'),
            ),
          ],
        ),
      ),
    );
  }
}

class HighscoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Highscores'),
      ),
      body: Center(
        child: Text('Highscores will be displayed here.'),
      ),
    );
  }
}

// This represents the game itself
class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

// In this class we define the basic functionality, the state of the game:
class _SnakeGameState extends State<SnakeGame> {
  static const int CELL_SIZE = 20;
  static const int GRID_WIDTH = 20;
  static const int GRID_HEIGHT = 35;
  static const int SPEED = 300;

  List<Point<int>> snake = [];
  Point<int> food = Point(0, 0);
  late Direction direction;
  late Timer timer;
  int score = 0; //  to track the score
// This method is called when the state object is inserted into the tree.
// It calls the startGame method to initialize the game.
  @override
  void initState() {
    super.initState();
    startGame();
  }

// This method is called when the state object is removed from the tree.
// It cancels the timer to stop the game loop.
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

// This method initializes the game by setting up the initial state of the snake,
// starting the game loop with a timer, and spawning the initial food.
  void startGame() {
    snake = [Point(5, 5), Point(5, 6), Point(5, 7)];
    direction = Direction.right;
    score = 0; // Reset score
    timer = Timer.periodic(Duration(milliseconds: SPEED), (Timer t) {
      updateGame();
    });
    spawnFood();
  }

  void updateGame() {
    Point<int> head = snake.first;
    Point<int> newHead = Point(0, 0);

    switch (direction) {
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
    }

    // Check if new head collides with the snake or hits the wall
    if (snake.contains(newHead) ||
        newHead.x < 0 ||
        newHead.x >= GRID_WIDTH ||
        newHead.y < 0 ||
        newHead.y >= GRID_HEIGHT) {
      timer.cancel(); // Stop the game
      gameOver();    // Display the game over menu
      return;
    }

    snake.insert(0, newHead);

    // Check if snake eats the food
    if (newHead == food) {
      score++; // Increment score when food is eaten
      spawnFood();
    } else {
      snake.removeLast();
    }

    setState(() {}); // Update UI
  }

  void spawnFood() {
    Random random = Random();
    int x, y;
    do {
      x = random.nextInt(GRID_WIDTH);
      y = random.nextInt(GRID_HEIGHT);
    } while (snake.contains(Point(x, y)));

    food = Point(x, y);
  }

 void gameOver() {
  showDialog(
    context: context,barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $score'), // Display final score
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    startGame(); // Restart the game
                  },
                  child: Text('PLAY AGAIN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement score submission
                  },
                  child: Text('SUBMIT SCORE'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the game screen
              },
              child: Text('EXIT'),
            ),
          ],
        ),
      );
    },
  );
}

  // Here we build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Score: $score',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && direction != Direction.up) {
                  direction = Direction.down;
                } else if (details.delta.dy < 0 && direction != Direction.down) {
                  direction = Direction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && direction != Direction.left) {
                  direction = Direction.right;
                } else if (details.delta.dx < 0 && direction != Direction.right) {
                  direction = Direction.left;
                }
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GRID_WIDTH,
                ),
                itemCount: GRID_WIDTH * GRID_HEIGHT,
                itemBuilder: (BuildContext context, int index) {
                  int x = index % GRID_WIDTH;
                  int y = index ~/ GRID_WIDTH;
                  Point<int> point = Point(x, y);
                  if (snake.contains(point)) {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Container(
                          width: CELL_SIZE * 1.3,
                          height: CELL_SIZE * 1.3,
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else if (food == point) {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Container(
                          width: CELL_SIZE * 1,
                          height: CELL_SIZE * 1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.black,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Defining the possible directions the snake can move.
enum Direction { up, down, left, right }

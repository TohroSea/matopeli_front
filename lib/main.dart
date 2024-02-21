import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'push_and_fetch_score.dart';
import 'main_menu.dart';

void main() {
  runApp(const SnakeGameApp());
}

// This class epresents the entire application
class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // MaterialApp widget, that provides app structure and theme.
      home: MainMenu(),
    );
  }
}

// This represents the game itself
class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

// In this class we define the basic functionality, the state of the game:
class _SnakeGameState extends State<SnakeGame> {
  static const int cellSize = 20;
  static const int gridWidth = 20;
  static const int gridHeight = 35;
  static const int initialSpeed = 300;
  static const int speedIncreaseAmount = 25; // Percentage increase in speed
  static const int foodPerSpeedIncrease = 2; // Number of foods eaten per speed increase;

   int get speed => initialSpeed - (speedIncreaseAmount * (foodsEaten ~/ foodPerSpeedIncrease));

  List<Point<int>> snake = [];
  Point<int> food = const Point(0, 0);
  late Direction direction;
  late Timer timer;
  int score = 0; //  to track the score
  int foodsEaten = 0; // to track the number of foods eaten

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
    snake = [const Point(5, 5), const Point(5, 6), const Point(5, 7)];
    direction = Direction.right;
    score = 0; // Reset score
    foodsEaten = 0; // Reset foods eaten count
    timer = Timer.periodic(const Duration(milliseconds: initialSpeed), (Timer t) {
      updateGame();
    });
    spawnFood();
  }

  void updateGame() {
    Point<int> head = snake.first;
    Point<int> newHead = const Point(0, 0);

    switch (direction) {
    case Direction.left:
      newHead = Point((head.x - 1 + gridWidth) % gridWidth, head.y);
      break;
    case Direction.right:
      newHead = Point((head.x + 1) % gridWidth, head.y);
      break;
    case Direction.up:
      newHead = Point(head.x, (head.y - 1 + gridHeight) % gridHeight);
      break;
    case Direction.down:
      newHead = Point(head.x, (head.y + 1) % gridHeight);
      break;
  }

    // Check if new head collides with the snake or hits the wall
    if (snake.contains(newHead) ||
        newHead.x < 0 ||
        newHead.x >= gridWidth ||
        newHead.y < 0 ||
        newHead.y >= gridHeight) {
      timer.cancel(); // Stop the game
      gameOver();    // Display the game over menu
      return;
    }
    snake.insert(0, newHead);

    // Check if snake eats the food
    if (newHead == food) {
      score++; // Increment score when food is eaten
      foodsEaten++; // Increment foods eaten count
      spawnFood();

      // Check if speed needs to be increased
      if (foodsEaten % foodPerSpeedIncrease == 0) {
        // Increase the initial speed by the speedIncreaseAmount
        timer.cancel();
        timer = Timer.periodic(Duration(milliseconds: speed), (Timer t) {
          updateGame();
        });
      }
    } else {
      snake.removeLast();
    }
    setState(() {}); // Update UI
  }

  void spawnFood() {
    Random random = Random();
    int x, y;
    do {
      x = random.nextInt(gridWidth);
      y = random.nextInt(gridHeight);
    } while (snake.contains(Point(x, y)));
    food = Point(x, y);
  }

 void gameOver() {
  showDialog(
    context: context,barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $score'), // Display final score
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    startGame(); // Restart the game
                  },
                  child: const Text('PLAY AGAIN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    showSubmitHighscore(score); // Restart the game
                  },
                  child: const Text('SUBMIT SCORE'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the game screen
              },
              child: const Text('EXIT'),
            ),
          ],
        ),
      );
    },
  );
}


void showSubmitHighscore(int score) {
    String username = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Highscore'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Points: $score'),
              TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle submitting the highscore
                pushHighscore(username, score);
                // print('Username: $username, Score: $score');
                Navigator.pop(context); // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
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
          const SizedBox(height: 50),
          Text(
            'Score: $score',
            style: const TextStyle(color: Colors.white, fontSize: 24),
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
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridWidth,
                ),
                itemCount: gridWidth * gridHeight,
                itemBuilder: (BuildContext context, int index) {
                  int x = index % gridWidth;
                  int y = index ~/ gridWidth;
                  Point<int> point = Point(x, y);
                  if (snake.contains(point)) {
                    return Container(
                      color: Color.fromARGB(255, 0, 0, 0),
                      child: Center(
                        child: Container(
                          width: cellSize * 1.3,
                          height: cellSize * 1.3,
                          color: Colors.green,
                        ),
                      ),
                    );
                  } else if (food == point) {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Container(
                          width: cellSize * 1,
                          height: cellSize * 1,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 76, 0, 255),
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
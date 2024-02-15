import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SnakeGameScreen(),
      ),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int gridSize = 20;
  static const int speed = 300;

  late List<int> snake;
  late int food;
  late Direction direction;
  late bool isPlaying;
  late int score;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    const startPosition = gridSize * gridSize ~/ 2;
    snake = [startPosition];
    food = _generateFood();
    direction = Direction.right;
    isPlaying = true;
    score = 0;

    Timer.periodic(Duration(milliseconds: speed), (Timer timer) {
      if (!isPlaying) {
        timer.cancel();
      } else {
        _moveSnake();
      }
    });
  }

  void _moveSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          if (snake.first < gridSize) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first - gridSize);
          break;
        case Direction.down:
          if (snake.first > (gridSize * gridSize) - gridSize) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first + gridSize);
          break;
        case Direction.left:
          if (snake.first % gridSize == 0) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first - 1);
          break;
        case Direction.right:
          if ((snake.first + 1) % gridSize == 0) {
            isPlaying = false;
            return;
          }
          snake.insert(0, snake.first + 1);
          break;
      }

      if (snake.first == food) {
        score++;
        food = _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  int _generateFood() {
    final random = Random();
    int foodIndex;
    do {
      foodIndex = random.nextInt(gridSize * gridSize);
    } while (snake.contains(foodIndex));
    return foodIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Column(
        children: [
          Text(
            'Score: $score',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: gridSize * gridSize,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (snake.contains(index)) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.green,
                  );
                } else if (food == index) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.black,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }

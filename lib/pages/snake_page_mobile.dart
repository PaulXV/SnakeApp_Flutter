import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakePageMobile extends StatefulWidget {
  const SnakePageMobile({super.key});

  @override
  State<SnakePageMobile> createState() => _SnakePageMobileState();
}

enum Direction { up, down, left, right }

class _SnakePageMobileState extends State<SnakePageMobile> {
  int noOfRow = 37, noOfColumn = 21;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHead = 0;
  int score = 0;
  late int foodPosition;
  late FocusNode focusNode;
  late Direction direction;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    startGame();
  }

  void despose() {
    focusNode.dispose();
    super.initState();
  }

  void startGame() {
    setState(() {
      score = 0;
      makeBorder();
      generateFood();
      direction = Direction.down;
      snakePosition = [50, 49, 48];
      snakeHead = snakePosition.first;
    });

    Timer.periodic(Duration(milliseconds: 150), (timer) {
      if(isPaused){
        updateSnake();
        if (checkCollision()) {
          isPaused = true;
          timer.cancel();
          showDialogBox();
        }
      }
    });
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text(
            "Your Final Score is: $score",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: const Text(
                  "Restart",
                )
            )
          ],
        );
      },
    );
  }

  bool checkCollision() {
    if (borderList.contains(snakeHead)) return true;
    if (snakePosition.sublist(1).contains(snakeHead)) return true;
    return false;
  }

  void generateFood() {
    foodPosition = Random().nextInt(noOfRow * noOfColumn);
    if (borderList.contains(foodPosition) ||
        snakePosition.contains(foodPosition)) {
      generateFood();
    }
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakePosition.insert(0, snakeHead - noOfColumn);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + noOfColumn);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;
      }
    });

    if (snakeHead == foodPosition) {
      score++;
      generateFood();
    } else {
      snakePosition.removeLast();
    }
    snakeHead = snakePosition.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Score: $score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
              });
            },
            icon: Icon(
              isPaused ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 33,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 && direction != Direction.up) {
            setState(() {
              direction = Direction.down;
            });
          } else if (details.delta.dy < 0 && direction != Direction.down) {
            setState(() {
              direction = Direction.up;
            });
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0 && direction != Direction.left) {
            setState(() {
              direction = Direction.right;
            });
          } else if (details.delta.dx < 0 && direction != Direction.right) {
            setState(() {
              direction = Direction.left;
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: groundForSnake(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade900,
        height: 40,
        notchMargin: 0,
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Text(
            'Swipe to change direction',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget groundForSnake() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: noOfRow * noOfColumn,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: noOfColumn,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: boxFillColor(index),
          margin: EdgeInsets.only(right: 0.4, bottom: 0.4),
        );
      },
    );
  }

  Color boxFillColor(int index) {
    if (borderList.contains(index)) {
      return Colors.grey.shade800;
    } else {
      if (snakePosition.contains(index)) {
        if (snakeHead == index) {
          return Colors.green.shade300;
        } else {
          return Colors.green.shade500;
        }
      } else {
        if (foodPosition == index) {
          return Colors.red;
        }
      }
    }
    return Colors.grey.shade600;
  }

  void makeBorder() {
    borderList.clear();
    for (int i = 0; i < noOfColumn; i++) {
      borderList.add(i);
      borderList.add(noOfColumn * (noOfRow - 1) + i);
    }
    for (int i = 0; i < noOfRow; i++) {
      borderList.add(i * noOfColumn);
      borderList.add(i * noOfColumn + noOfColumn - 1);
    }
  }

}
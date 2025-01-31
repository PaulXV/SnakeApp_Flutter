// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class SnakePagePc extends StatefulWidget {
  const SnakePagePc({super.key});

  @override
  State<SnakePagePc> createState() => _SnakePagePcState();
}

enum Direction { up, down, left, right }

class _SnakePagePcState extends State<SnakePagePc> {
  int noOfRow = 19, noOfColumn = 38;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHeade = 0;
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
      direction = Direction.right;
      snakePosition = [50, 49, 48];
      snakeHeade = snakePosition.first;
    });

    Timer.periodic(Duration(milliseconds: 120), (timer) {
      if(isPaused){
        updateSnake();
        if (checkCollision()) {
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
                  setState(() {
                    isPaused = true;
                  });
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
    if (borderList.contains(snakeHeade)) return true;
    if (snakePosition.sublist(1).contains(snakeHeade)) return true;
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
          snakePosition.insert(0, snakeHeade - noOfColumn);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHeade + noOfColumn);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHeade + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHeade - 1);
          break;
      }
    });

    if (snakeHeade == foodPosition) {
      score++;
      generateFood();
    } else {
      snakePosition.removeLast();
    }
    snakeHeade = snakePosition.first;
  }

  void handledKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW:
          if (direction != Direction.down) direction = Direction.up;
          break;
        case LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS:
          if (direction != Direction.up) direction = Direction.down;
          break;
        case LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA:
          if (direction != Direction.right) direction = Direction.left;
          break;
        case LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD:
          if (direction != Direction.left) direction = Direction.right;
          break;
        case LogicalKeyboardKey.space:
          setState(() {
            isPaused = !isPaused;
          });
          break;
      }
    }
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
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RawKeyboardListener(
        focusNode: focusNode,
        onKey: handledKey,
        autofocus: true,
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
        child: Center(
          child: Text(
            "Press Space to Pause/Play",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget groundForSnake() {
    return GridView.builder(
      itemCount: noOfRow * noOfColumn,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: noOfColumn,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: boxFillColor(index),
        );
      },
    );
  }

  Color boxFillColor(int index) {
    if (borderList.contains(index)) {
      return Colors.grey.shade800;
    } else {
      if (snakePosition.contains(index)) {
        if (snakeHeade == index) {
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
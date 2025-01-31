import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_app/components/my_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void toSnakeGame(BuildContext context) {
    
    if (MediaQuery.of(context).size.width > 768) {
      Navigator.pushNamed(context, '/snake_pc');
    } else {
      Navigator.pushNamed(context, '/snake_mobile');
    }
  }

  void exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color(0xFF1B5E20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/snake.json',
                width: 300,
                height: 300,
                frameRate: FrameRate.max,
              ),
              const SizedBox(height: 20),
              Text(
                'Snake',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                      text: "Play",
                      onTap: () => toSnakeGame(context),
                      color: Colors.green),
                  const SizedBox(width: 20),
                  MyButton(
                      text: "Exit", onTap: () => exitApp(), color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
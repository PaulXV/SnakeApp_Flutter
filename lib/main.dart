import 'package:flutter/material.dart';
import 'package:snake_app/pages/home_page.dart';
import 'package:snake_app/pages/snake_page_mobile.dart';
import 'package:snake_app/pages/snake_page_pc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/snake_mobile': (context) => const SnakePageMobile(),
        '/snake_pc': (context) => const SnakePagePc(),
      },
    );
  }
}
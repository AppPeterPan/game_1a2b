import 'package:flutter/material.dart';
import 'package:game_1a2b/page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const HomePage());
  }
}

import 'package:flutter/material.dart';
import 'package:sudokuapp/screens/HomeView.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo Sudoku',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeView(),
    );
  }
}

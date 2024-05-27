import 'package:flutter/material.dart';
import 'package:mathboi_21/fractal_view.dart';

void main() {
  runApp(const MyApp());
}

///TODO make it run the algorithm on Isolates so that it does not become unresponsive.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Birthday',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SafeArea(
        child: MyHomePage(),
      ),
    );
  }
}

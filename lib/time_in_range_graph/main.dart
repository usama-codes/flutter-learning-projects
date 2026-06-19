import 'package:flutter/material.dart';
import 'package:learning/time_in_range_graph/tir_vu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: TIRVU(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:learning/data_table_scratch/data_table_vu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Data Table",
      home: MyDataTableVU(),
    );
  }
}

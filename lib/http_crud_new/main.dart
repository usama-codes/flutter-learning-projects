import 'package:flutter/material.dart';
import 'package:learning/http_crud_new/http_crud_vu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HTTP CRUD",
      home: HttpCrudVU(),
    );
  }
}

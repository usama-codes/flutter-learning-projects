import 'package:flutter/material.dart';
import 'package:learning/data_table/api_client.dart';
import 'package:learning/data_table/data_table_vu.dart';

void main() {
  ApiClient.instance = ApiClient(baseUrl: 'http://localhost:4000');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Articles',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF4F6AF5),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
      ),
      home: buildArticlesScreen(
        extraActionsBuilder: (context) => [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'People',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => buildPeopleScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:learning/navigation_app/custom/push_named.dart';
import 'package:learning/navigation_app/custom/push_named_and_remove_until.dart';
import 'package:learning/navigation_app/custom/push_replacement.dart';
import 'package:learning/navigation_app/custom/push_replacement_named.dart';
import 'package:learning/navigation_app/navigation_vu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => NavigationVU(),
        '/pushNamed': (context) => const PushNamed(),
        '/pushNamedAndRemoveUntil' : (context) => PushNamedAndRemoveUntil(),
        '/pushReplacementNamed' : (context) => PushReplacementNamed(),
        '/pushReplacement' : (context) => PushReplacement(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
    );
  }
}

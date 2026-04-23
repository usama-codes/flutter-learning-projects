import 'dart:async';
import 'package:custom_button/crud/crud_vu.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CrudVU()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FlutterLogo(
                size: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text("Welcome To CHI", style: TextStyle(fontSize: 24)),
            ),
            const Text("HTTP Crud App", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

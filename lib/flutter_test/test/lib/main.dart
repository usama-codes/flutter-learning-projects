import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test/pay/pay_vu.dart';
// import 'package:test/stripe/stripe_vu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Stripe.publishableKey =
        'pk_test_51TjZ3iGpAI7zKutJlGf81IUCTnv1ayLKU7mMio5S0FavKoZW1UL4b2z5FYPWvCvQEW7jpJX6YlDvIYI7mi6QUcJ400tOF9FLvS';
    await Stripe.instance.applySettings();
  } catch (e) {
    debugPrint("Stripe init failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Gateway',
      home: PayVU(),
    );
  }
}

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

class StripeVM extends BaseViewModel {
  dynamic createPaymentIntent(String amount, String currency) async {
    final body = {'amount': amount, 'currency': currency};

    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.118:3000/create-payment-intent'),
        body: body,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      return jsonDecode(response.body);
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      final paymentData = await createPaymentIntent('100', 'USD') ?? {};

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentData['client_secret'],
              style: ThemeMode.light,
              customFlow: false,
              merchantDisplayName: 'Osama',
            ),
          )
          .then((value) {
            displayPaymentSheet(context);
          });
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  void displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Paid Successfully!")));
          })
          .onError((error, stackTrace) {
            throw Exception(error);
          });
    } on StripeException catch (e) {
      print('Error is --> $e');
    }
  }
}

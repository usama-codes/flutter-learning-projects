import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test/stripe/stripe_vm.dart';

class StripeVU extends StackedView<StripeVM> {
  const StripeVU({super.key});

  @override
  Widget builder(
    BuildContext context,
    StripeVM viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Integration")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            viewModel.makePayment(context);
          },
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.cyan.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pay Now!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  StripeVM viewModelBuilder(BuildContext context) {
    return StripeVM();
  }
}

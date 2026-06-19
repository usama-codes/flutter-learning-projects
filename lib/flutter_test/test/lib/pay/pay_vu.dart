import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test/pay/pay_vm.dart';

class PayVU extends StackedView<PayVM> {
  const PayVU({super.key});

  @override
  Widget builder(BuildContext context, PayVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Modules')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Platform.isIOS
              ? viewModel.applePayButton
              : viewModel.googlePlayButton,
        ),
      ),
    );
  }

  @override
  PayVM viewModelBuilder(BuildContext context) {
    return PayVM();
  }
}

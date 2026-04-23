import 'package:custom_button/navigation_app/navigation_vm.dart';
import 'package:custom_button/navigation_app/navigation_vu.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PushReplacement extends StackedView<NavigationVM> {
  const PushReplacement({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push Replacement")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with pushReplacement."),
            ElevatedButton(
              onPressed: () => viewModel.pushReplacementNamed(context),
              child: const Text("Replace With pushReplacementNamed"),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationVU())),
              child: const Text("Go Home"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  NavigationVM viewModelBuilder(BuildContext context) {
    return NavigationVM();
  }
}

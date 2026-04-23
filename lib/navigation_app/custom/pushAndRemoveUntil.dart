import 'package:custom_button/navigation_app/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PushAndRemoveUntil extends StackedView<NavigationVM> {
  const PushAndRemoveUntil({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push And Remove Until")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with pushAndRemoveUntil (stack cleared)."),
            ElevatedButton(
              onPressed: () => viewModel.pushAndRemoveUntil(context),
              child: const Text("Run pushAndRemoveUntil Again"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
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

import 'package:flutter/material.dart';
import 'package:learning/navigation_app/navigation_vm.dart';
import 'package:stacked/stacked.dart';

class PushRoute extends StackedView<NavigationVM> {
  const PushRoute({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with push. Back returns to previous page."),
            ElevatedButton(
              onPressed: () => viewModel.push(context),
              child: const Text("Push Again"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Pop"),
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

import 'package:custom_button/navigation_app/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PushNamed extends StackedView<NavigationVM> {
  const PushNamed({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push Named")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with pushNamed."),
            ElevatedButton(
              onPressed: () => viewModel.pushNamed(context),
              child: const Text("Push Named Again"),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/pushNamedAndRemoveUntil'),
              child: const Text("Go To Remove Until Demo"),
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

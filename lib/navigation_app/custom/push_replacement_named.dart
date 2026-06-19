// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:learning/navigation_app/navigation_vm.dart';
import 'package:stacked/stacked.dart';

class PushReplacementNamed extends StackedView<NavigationVM> {
  const PushReplacementNamed({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push Replacement Named")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with pushReplacementNamed."),
            ElevatedButton(
              onPressed: () => viewModel.pushNamed(context),
              child: const Text("Open pushNamed"),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
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

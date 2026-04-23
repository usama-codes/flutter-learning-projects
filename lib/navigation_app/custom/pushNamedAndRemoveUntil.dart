import 'package:custom_button/navigation_app/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PushNamedAndRemoveUntil extends StackedView<NavigationVM> {
  const PushNamedAndRemoveUntil({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push Named And Remove Until")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Text("Opened with pushNamedAndRemoveUntil."),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
              child: const Text("Reset To Home"),
            ),
            TextButton(
              onPressed: () => viewModel.pushNamed(context),
              child: const Text("Open pushNamed"),
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

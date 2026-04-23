import 'package:custom_button/navigation_app/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NavigationVU extends StackedView<NavigationVM> {
  const NavigationVU({super.key});

  @override
  Widget builder(BuildContext context, NavigationVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation App")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => viewModel.push(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Push"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.pushReplacement(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Push Replacement"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.pushNamed(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Push Named"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.pushReplacementNamed(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Push Replacement Named"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.pushAndRemoveUntil(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Push and Remove Until"),
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

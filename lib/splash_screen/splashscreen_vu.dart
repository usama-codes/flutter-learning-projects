import 'package:custom_button/splash_screen/splashscreen_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashscreenVU extends StackedView<SplashScreenVM> {
  const SplashscreenVU({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    viewModel.navigateAfterDelay(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FlutterLogo(
                size: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text("Welcome To CHI", style: TextStyle(fontSize: 24)),
            ),
            const Text("HTTP Crud App", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return SplashScreenVM();
  }
}

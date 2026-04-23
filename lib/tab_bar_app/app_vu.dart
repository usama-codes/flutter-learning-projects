import 'package:custom_button/tab_bar_app/app_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppVU extends StackedView<AppVM> {
  const AppVU({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

import 'package:custom_button/tab_bar_app/app_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Status extends StackedView<AppVM> {
  const Status({super.key});

  @override
  Widget builder(BuildContext context, AppVM viewModel, Widget? child) {
    return Scaffold();
  }

  @override
  AppVM viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

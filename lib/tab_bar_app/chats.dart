import 'package:custom_button/tab_bar_app/app_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Chats extends StackedView<AppVM> {
  const Chats({super.key});

  @override
  Widget builder(BuildContext context, AppVM viewModel, Widget? child) {
    return Scaffold();
  }

  @override
  AppVM viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

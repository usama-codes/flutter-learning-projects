import 'package:custom_button/tab_bar_app/app_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TabBar extends StackedView<AppVM> {
  const TabBar({super.key});

  @override
  Widget builder(BuildContext context, AppVM viewModel, Widget? child) {
    return Row(
      children: [
        Icon(Icons.chat_bubble_outline),
        Icon(Icons.bubble_chart),
        Icon(Icons.call),
      ],
    );
  }

  @override
  AppVM viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

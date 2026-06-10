import 'app_vm.dart';
import 'calls.dart';
import 'chats.dart';
import 'status.dart';
import 'tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppVU extends StackedView<AppVM> {
  const AppVU({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Tab Bar App")),
      body: Column(
        children: [
          const MyTabBar(),

          if (viewModel.isChat) const Chats(),
          if (viewModel.isStatus) const Status(),
          if (viewModel.isCall) const Calls(),
        ],
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

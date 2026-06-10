import 'app_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MyTabBar extends ViewModelWidget<AppVM> {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context, AppVM viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        height: 45,
        child: ColoredBox(
          color: Colors.greenAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: viewModel.showChat,
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: viewModel.isChat ? Colors.blue : Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: viewModel.showStatus,
                icon: Icon(
                  Icons.bubble_chart,
                  color: viewModel.isStatus ? Colors.blue : Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: viewModel.showCalls,
                icon: Icon(
                  Icons.call,
                  color: viewModel.isCall ? Colors.blue : Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

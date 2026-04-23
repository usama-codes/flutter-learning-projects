import 'package:custom_button/counter/counter_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CounterVU extends StackedView<CounterVM> {
  const CounterVU({super.key});

  @override
  Widget builder(BuildContext context, CounterVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter ListView")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.counter.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('${viewModel.counter[index]}'),
                selected: viewModel.selectedIndex == index,
                onTap: () => viewModel.selectIndex(index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: [
                ElevatedButton(onPressed: viewModel.add, child: Text('Add')),
                ElevatedButton(
                  onPressed: viewModel.counter.isEmpty
                      ? null
                      : () => viewModel.remove(viewModel.selectedIndex),
                  child: Text("Remove"),
                ),
                ElevatedButton(onPressed: viewModel.reset, child: Text("Reset")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  CounterVM viewModelBuilder(BuildContext context) {
    return CounterVM();
  }
}

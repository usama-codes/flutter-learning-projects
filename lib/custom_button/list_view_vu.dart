import 'package:flutter/material.dart';
import 'package:learning/custom_button/list_view_vm.dart';
import 'package:learning/custom_button/person.dart';
import 'package:stacked/stacked.dart';

class ListViewVU extends StackedView<ListViewVM> {
  final String name;
  final int age;

  const ListViewVU({super.key, required this.name, required this.age});

  @override
  Widget builder(BuildContext context, ListViewVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Button App")),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Person.people.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 15.0,
                  ),
                  child: ListTile(
                    leading: Text(
                      Person.people[index].name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      '${Person.people[index].age}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    tileColor: const Color.fromARGB(255, 234, 228, 209),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: viewModel.controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Enter something",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => viewModel.sendBack(context),
                    child: const Text("Send Back"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ListViewVM viewModelBuilder(BuildContext context) {
    return ListViewVM();
  }
}

import 'package:custom_button/custom_button/list_view_vm.dart';
import 'package:custom_button/custom_button/person.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ListViewVU extends StackedView<ListViewVM> {
  final String name;
  final int age;

  const ListViewVU({super.key, required this.name, required this.age});

  @override
  Widget builder(BuildContext context, ListViewVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Button App")),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
                style: TextStyle(fontSize: 16),
              ),
              trailing: Text(
                '${Person.people[index].age}',
                style: TextStyle(fontSize: 16),
              ),
              tileColor: const Color.fromARGB(255, 234, 228, 209),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  ListViewVM viewModelBuilder(BuildContext context) {
    return ListViewVM();
  }
}

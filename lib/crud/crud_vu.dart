import 'package:custom_button/crud/crud_vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CrudVU extends StackedView<CrudVM> {
  const CrudVU({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome To CHI")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 15.0,
                  ),
                  child: TextFormField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Name",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: viewModel.ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Age",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  viewModel.nameAlert,
                  style: TextStyle(
                    color: viewModel.nameController.text.isEmpty
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  viewModel.ageAlert,
                  style: TextStyle(
                    color: viewModel.ageController.text.isEmpty
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: viewModel.people.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.green.shade900,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Icon(Icons.person),
                    horizontalTitleGap: 30,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.people.keys.elementAt(index)),
                        Text("${viewModel.people.values.elementAt(index)}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: IconButton(
                            onPressed: () => viewModel.edit(index),
                            icon: Icon(Icons.edit),
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () => viewModel.delete(index),
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.add(index: viewModel.editingIndex),
        child: viewModel.isEditing ? Icon(Icons.edit) : Icon(Icons.add),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return CrudVM();
  }
}

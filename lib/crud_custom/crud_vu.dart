import 'package:flutter/material.dart';
import 'package:learning/crud_custom/crud_vm.dart';
import 'package:learning/crud_custom/custom_tile.dart';
import 'package:learning/crud_custom/error_messages.dart';
import 'package:learning/crud_custom/text_fields.dart';
import 'package:stacked/stacked.dart';

class CustomCrudVU extends StackedView<CustomCrudVM> {
  const CustomCrudVU({super.key});

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome To CHI")),
      body: Column(
        children: [
          TextFields(viewModel.nameController, viewModel.ageController),
          ErrorMessages(
            viewModel.nameAlert,
            viewModel.ageAlert,
            viewModel.nameController,
            viewModel.ageController,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: viewModel.people.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Tile(
                    viewModel.people,
                    index,
                    viewModel.edit,
                    viewModel.delete,
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
    return CustomCrudVM();
  }
}

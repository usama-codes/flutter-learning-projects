import 'package:custom_button/custom_button/button.dart';
import 'package:custom_button/custom_button/button_app_vm.dart';
import 'package:custom_button/custom_button/person.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ButtonAppVU extends StackedView<ButtonAppVM> {
  const ButtonAppVU({super.key});

  @override
  Widget builder(BuildContext context, ButtonAppVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Button App")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      labelText: "Enter name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: viewModel.ageController,
                    decoration: InputDecoration(
                      labelText: "Enter age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Text(
                    "Please fill this field",
                    style: TextStyle(
                      color: viewModel.isNameEmpty
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Please fill this field",
                    style: TextStyle(
                      color: viewModel.isAgeEmpty
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: CHIButton(
                label: "Save",
                icon: viewModel.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 55, 57, 199),
                          strokeWidth: 2,
                        ),
                      )
                    : const SizedBox.shrink(),
                backgroundColor: const Color.fromARGB(255, 62, 214, 115),
                textColor: Colors.white,
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.add(
                        Person(
                          viewModel.nameController.text,
                          int.tryParse(viewModel.ageController.text) ?? -1,
                        ),
                        context,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ButtonAppVM viewModelBuilder(BuildContext context) {
    return ButtonAppVM();
  }
}

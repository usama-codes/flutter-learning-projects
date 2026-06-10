import 'package:flutter/material.dart';
import 'package:learning/custom_button/button.dart';
import 'package:learning/custom_button/button_app_vm.dart';
import 'package:stacked/stacked.dart';

class ButtonAppVU extends StackedView<ButtonAppVM> {
  const ButtonAppVU({super.key});

  @override
  Widget builder(BuildContext context, ButtonAppVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Button App")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Form(
          // autovalidateMode: AutovalidateMode.,
          key: viewModel.formKey,
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please fill out the field';
                        }
                        return null;
                      },
                      controller: viewModel.nameController,
                      decoration: InputDecoration(
                        labelText: "Enter name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please fill out the field';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Age must be a number';
                        }
                        return null;
                      },
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
                children: [
                  Expanded(
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
                          : () => viewModel.addAndSave(context),
                    ),
                  ),
                ],
              ),
              Text(viewModel.data ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ButtonAppVM viewModelBuilder(BuildContext context) {
    return ButtonAppVM();
  }
}

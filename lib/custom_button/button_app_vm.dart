import 'package:flutter/material.dart';
import 'package:learning/custom_button/list_view_vu.dart';
import 'package:learning/custom_button/person.dart';
import 'package:stacked/stacked.dart';

class ButtonAppVM extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isLoading = false;
  String? data;

  Future<void> addAndSave(BuildContext context) async {
    if (isLoading) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final person = Person(
      nameController.text,
      int.tryParse(ageController.text) ?? -1,
    );
    Person.people.add(person);

    isLoading = true;
    notifyListeners();

    final enteredName = nameController.text;
    final enteredAge = int.tryParse(ageController.text) ?? -1;
    nameController.clear();
    ageController.clear();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => ListViewVU(name: enteredName, age: enteredAge),
      ),
    );

    if (result != null && result.isNotEmpty) {
      data = result;
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}

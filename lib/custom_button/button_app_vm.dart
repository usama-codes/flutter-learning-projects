import 'package:custom_button/custom_button/list_view_vu.dart';
import 'package:custom_button/custom_button/person.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ButtonAppVM extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isAgeEmpty = false;
  bool isNameEmpty = false;
  bool isLoading = false;

  Future<void> save(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListViewVU(
          name: nameController.text,
          age: int.tryParse(ageController.text) ?? -1,
        ),
      ),
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> add(Person person, BuildContext context) async {
    if (isLoading) return;

    isNameEmpty = nameController.text.isEmpty;
    isAgeEmpty = ageController.text.isEmpty;

    if (!isNameEmpty && !isAgeEmpty) {
      Person.people.add(person);
      nameController.clear();
      ageController.clear();
      await save(context);
    }

    notifyListeners();
  }
}

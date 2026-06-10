import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppVM extends BaseViewModel {
  bool isLightOn = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Map<String, int> people = {};
  bool isNameEmpty = false;
  bool isAgeEmpty = false;

  void showFields() {
    isLightOn = !isLightOn;
    notifyListeners();
  }

  void save() {
    isNameEmpty = nameController.text.isEmpty;
    isAgeEmpty = ageController.text.isEmpty;

    if (!isNameEmpty && !isAgeEmpty) {
      people[nameController.text.toString()] =
          int.tryParse(ageController.text.toString()) ?? -1;
      nameController.clear();
      ageController.clear();
    }

    notifyListeners();
  }
}

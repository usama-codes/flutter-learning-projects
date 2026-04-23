import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomCrudVM extends BaseViewModel {
  Map<String, int> people = {};
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String nameAlert = "";
  String ageAlert = "";
  bool isEditing = false;
  int? editingIndex;
  String? name;
  int? age;

  void add({int? index}) {
    if (index != null) {
      String newName = nameController.text;
      int newAge = int.tryParse(ageController.text) ?? 0;

      if (newName != name) {
        people[newName] = newAge;

        people.remove(name);
      } else {
        people[newName] = newAge;
      }

      isEditing = false;
      editingIndex = null;
      nameController.clear();
      ageController.clear();
    } else {
      if (nameController.text.isEmpty || ageController.text.isEmpty) {
        nameAlert = "Please enter a name";
        ageAlert = "Please enter an age";
      } else {
        people[nameController.text] = int.tryParse(ageController.text) ?? 0;
        nameController.clear();
        ageController.clear();
        ageAlert = "";
        nameAlert = "";
      }
    }
    notifyListeners();
  }

  void edit(int index) {
    isEditing = true;
    name = people.keys.elementAt(index);
    age = people.values.elementAt(index);
    editingIndex = index;

    nameController.text = name!;
    ageController.text = age.toString();

    notifyListeners();
  }

  void delete(int index) {
    String name = people.keys.elementAt(index);
    people.remove(name);

    notifyListeners();
  }
}

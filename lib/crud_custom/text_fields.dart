import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  const TextFields(this.nameController, this.ageController, {super.key});

  final TextEditingController nameController;
  final TextEditingController ageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: TextFormField(
              controller: nameController,
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
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Age",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

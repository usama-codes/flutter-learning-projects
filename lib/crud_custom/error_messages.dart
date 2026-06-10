import 'package:flutter/material.dart';

class ErrorMessages extends StatelessWidget {
  final String nameAlert;
  final String ageAlert;
  final TextEditingController nameController;
  final TextEditingController ageController;


  const ErrorMessages(this.nameAlert, this.ageAlert, this.nameController, this.ageController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  nameAlert,
                  style: TextStyle(
                    color: nameController.text.isEmpty
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  ageAlert,
                  style: TextStyle(
                    color: ageController.text.isEmpty
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
            ],
          );
  }
}
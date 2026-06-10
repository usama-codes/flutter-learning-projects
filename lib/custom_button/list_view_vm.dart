import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ListViewVM extends BaseViewModel {
  TextEditingController controller = TextEditingController();

  void sendBack(BuildContext context) {
    String data = controller.text;

    Navigator.pop(context, data);
  }
}

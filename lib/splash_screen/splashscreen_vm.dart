import 'dart:async';

import 'package:custom_button/crud/crud_vu.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashScreenVM extends BaseViewModel {
  void navigateAfterDelay(BuildContext context) {
    Timer(
      Duration(seconds: 3),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CrudVU()),
      ),
    );
  }
}

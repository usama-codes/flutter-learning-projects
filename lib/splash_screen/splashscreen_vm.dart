import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learning/crud/crud_vu.dart';
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

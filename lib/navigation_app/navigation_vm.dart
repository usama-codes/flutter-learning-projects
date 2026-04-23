import 'package:custom_button/navigation_app/custom/push.dart';
import 'package:custom_button/navigation_app/custom/pushAndRemoveUntil.dart';
import 'package:custom_button/navigation_app/custom/pushReplacement.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NavigationVM extends BaseViewModel {
  void push(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PushRoute()),
    );
  }

  void pushNamedAndRemoveUntil(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/pushNamedAndRemoveUntil',
      ModalRoute.withName('/home'),
    );
  }

  void pushAndRemoveUntil(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => PushAndRemoveUntil()),
      (route) => false,
    );
  }

  void pushReplacementNamed(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/pushReplacementNamed');
  }

  void pushNamed(BuildContext context) {
    Navigator.of(context).pushNamed('/pushNamed');
  }

  void pushReplacement(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PushReplacement()),
    );
  }
}

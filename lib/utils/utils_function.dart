import 'package:flutter/material.dart';

class UtilsFunction {
  static void navigation(BuildContext context, Widget destination) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => destination));
  }

  static void redirectAfterDelay(BuildContext context, Widget destination) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    });
  }
}

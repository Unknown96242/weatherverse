import 'package:flutter/material.dart';

class UtilsFunction {

   static void navigation(dynamic context, Widget destination ){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>  destination,
      ),
    );
  }
}
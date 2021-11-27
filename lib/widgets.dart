import 'package:flutter/material.dart';

floatingButton(String text, Function functionName) {
  Widget floatingbutton = FloatingActionButton(
      onPressed: () {
        functionName();
      },
      child: Text(text));
  return floatingbutton;
}

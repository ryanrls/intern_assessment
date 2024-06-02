import 'package:flutter/material.dart';

class Component {
  Widget textfield(
      BuildContext context, TextEditingController controller, bool obscureText,
      {InputDecoration? decoration}) {
    return TextFormField(
      controller: controller,
      decoration: decoration,
      obscureText: obscureText,
    );
  }

  Widget loginButton(
      BuildContext context, String text, ElevatedButton? Function() onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        child: Text(text));
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));
  }
}

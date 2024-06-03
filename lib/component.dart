import 'package:flutter/material.dart';

class Component {
  List<String> taskStatus = ["To-Do", "Urgent", "Done"];

  Widget textfield(
      BuildContext context, TextEditingController controller, bool obscureText,
      {InputDecoration? decoration, void Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      decoration: decoration,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  Widget loginButton(
      BuildContext context, String text, Future<void> Function()? onPressed,
      {Color? backgroundColor, Color? textColor}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ));
  }

  Widget subheader(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Future<DateTime?> showDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      return date;
    }

    return null;
  }

  Future<TimeOfDay?> showTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (time != null) {
      return time;
    }

    return null;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      BuildContext context, String message, bool error) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error == true
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  InputDecoration dateTimeTextFieldStyle(BuildContext context, String text,
      {required Widget prefixIcon}) {
    return InputDecoration(
        labelText: text,
        filled: true,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onInverseSurface)));
  }
}

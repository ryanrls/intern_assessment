import 'package:flutter/material.dart';
import 'package:intern_assessment/component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Component().appBar(context, title: const Text('Reset Password')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Component().textfield(context, _pwController, true,
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (value) {
              if (_pwController.text.isEmpty || _pwController.text == "") {
                return "Please Fill in New Password";
              } else if (_pwController.text != _confirmController.text) {
                return "Password does not match";
              }
              return null;
            }),
            Component().textfield(context, _confirmController, true,
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
                validator: (value) {
              if (_pwController.text.isEmpty || _pwController.text == "") {
                return "Please Fill in Confirm Password";
              } else if (_pwController.text != _confirmController.text) {
                return "Password does not match";
              }
              return null;
            }),
            Component().submitButton(context, "Change Password", () async {
              if (_formKey.currentState!.validate()) {
                if (_pwController.text == _confirmController.text) {
                  await supabase.auth.updateUser(
                    UserAttributes(
                      password: _confirmController.text,
                    ),
                  );
                  supabase.auth.signOut();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                }
              } else {
                return;
              }
            })
          ],
        ),
      ),
    );
  }
}

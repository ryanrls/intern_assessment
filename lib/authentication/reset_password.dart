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
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Column(
        children: [
          Component().textfield(context, _pwController, true,
              decoration: const InputDecoration(labelText: "New Password")),
          Component().textfield(context, _confirmController, true,
              decoration: const InputDecoration(labelText: "Confirm Password")),
          Component().submitButton(context, "Change Password", () async {
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
            } else {
              return;
            }
          })
        ],
      ),
    );
  }
}

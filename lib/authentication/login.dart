// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/authentication_dao.dart';
import 'package:intern_assessment/backend/controller.dart';
import 'package:intern_assessment/component.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Component().textfield(context, _emailController, false,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } else if (!Validator().isEmail(value)) {
                  return "Please Enter Valid Email";
                }
                return null;
              }),
              Component().textfield(context, _passwordController, true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                if (value!.isEmpty || value == "") {
                  return "Please Enter Password";
                }
                return null;
              }),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Component().submitButton(context, "Login", () async {
                      if (_formKey.currentState!.validate()) {
                        Authentication().login(_emailController.text,
                            _passwordController.text, context);
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Component().submitButton(context, "Register",
                          () async {
                        Navigator.pushNamed(context, '/register');
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Text(
                  "Forget Password?",
                  style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                      decoration: TextDecoration.underline),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/forget_password');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

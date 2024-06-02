// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/authentication_dao.dart';
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
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Component().textfield(context, _emailController, false,
                  decoration: const InputDecoration(labelText: 'Email')),
              Component().textfield(context, _passwordController, true,
                  decoration: const InputDecoration(labelText: 'Password')),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Component().loginButton(context, "Login", () async {
                  Authentication().login(
                      _emailController.text, _passwordController.text, context);
                }),
              ),
              Component().loginButton(context, "Register", () async {
                Navigator.pushNamed(context, '/register');
              }),
            ],
          ),
        ),
      ),
    );
  }
}

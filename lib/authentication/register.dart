import 'package:flutter/material.dart';
import 'package:intern_assessment/DAO/authentication_dao.dart';
import 'package:intern_assessment/component.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Component().textfield(context, _nameController, false,
                    decoration: const InputDecoration(labelText: 'Name')),
                Component().textfield(context, _emailController, false,
                    decoration: const InputDecoration(labelText: 'Email')),
                Component().textfield(context, _passwordController, false,
                    decoration: const InputDecoration(labelText: 'Password')),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Component().loginButton(context, 'Submit', () {
                    Authentication().register(_nameController.text,
                        _emailController.text, _passwordController.text);
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

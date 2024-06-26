import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/authentication_dao.dart';
import 'package:intern_assessment/backend/controller.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Component().appBar(context, title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Component().textfield(context, _nameController, false,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please Enter Name";
                  }
                  return null;
                }),
                Component().textfield(context, _emailController, false,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please Enter Email";
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
                  } else if (value.length < 6) {
                    return "Password must be length 6 or more";
                  }
                  return null;
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Component().submitButton(context, 'Submit', () async {
                    if (_formKey.currentState!.validate()) {
                      Authentication().register(
                          _nameController.text.toUpperCase(),
                          _emailController.text,
                          _passwordController.text,
                          context);
                    }
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

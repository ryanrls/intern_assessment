import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/controller.dart';
import 'package:intern_assessment/backend/user_dao.dart';
import 'package:intern_assessment/component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final supabase = Supabase.instance.client;
  dynamic data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    data = UserDAO().getUserInfo(supabase.auth.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Component().appBar(context, title: const Text('Edit Profile')),
        body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else {
                final userData = snapshot.data as List<dynamic>;
                _nameController.text = userData[0]['name'];
                _emailController.text = userData[0]['email'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Component().textfield(context, _nameController, false,
                            decoration:
                                const InputDecoration(labelText: "Name"),
                            validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Please Enter Name";
                          }
                          return null;
                        }),
                        Component().textfield(context, _emailController, false,
                            decoration:
                                const InputDecoration(labelText: "Email"),
                            validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "Please Enter Email";
                          } else if (!Validator().isEmail(value)) {
                            return "Please Enter Valid Email";
                          }
                          return null;
                        }),
                        Component().textfield(
                            context, _passwordController, true,
                            decoration: const InputDecoration(
                                labelText:
                                    "Enter Password if you want to change it"),
                            validator: (value) {
                          if (value!.isNotEmpty && value.length < 6) {
                            return "Password must be length 6 or more";
                          }
                          return null;
                        }),
                        Component().submitButton(context, "Edit Profile",
                            () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text != "" ||
                                  _passwordController.text.isNotEmpty) {
                                await supabase.auth.updateUser(UserAttributes(
                                    email: _emailController.text,
                                    password: _passwordController.text));
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/homepage', (route) => false);
                                }
                              } else {
                                isLoading = true;
                                await supabase.auth.updateUser(UserAttributes(
                                  email: _emailController.text,
                                ));
                                await supabase.from('user').update({
                                  'name': _nameController.text.toUpperCase(),
                                  'email': _emailController.text
                                }).eq('id', supabase.auth.currentUser!.id);

                                print(
                                    "User ID: ${supabase.auth.currentUser!.id}");
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/homepage', (route) => false);
                                }
                              }
                            }
                          } on AuthApiException {
                            if (context.mounted) {
                              Component().snackBar(
                                  context,
                                  "Password cannot be same from old password",
                                  true);
                            }
                          }
                        })
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}

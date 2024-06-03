import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/todo_dao.dart';
import 'package:intern_assessment/backend/user_dao.dart';
import 'package:intern_assessment/component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var data;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    data = UserDAO().getUserInfo(supabase.auth.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else {
                final userData = snapshot.data as List<dynamic>;
                _nameController.text = userData[0]['name'];
                _emailController.text = userData[0]['email'];

                return Column(
                  children: [
                    Component().textfield(context, _nameController, false,
                        decoration: const InputDecoration(labelText: "Name")),
                    Component().textfield(context, _emailController, false,
                        decoration: const InputDecoration(labelText: "Email")),
                    Component().textfield(context, _passwordController, false,
                        decoration: const InputDecoration(
                            labelText:
                                "Enter Password if you want to change it")),
                    Component().submitButton(context, "Edit Profile", () async {
                      if (_passwordController.text != "" ||
                          _passwordController.text.isNotEmpty) {
                        await supabase.auth.updateUser(UserAttributes(
                            email: _emailController.text,
                            password: _passwordController.text));
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await supabase.auth.updateUser(UserAttributes(
                          email: _emailController.text,
                        ));
                        await supabase.from('user').update({
                          'name': _nameController.text.toUpperCase(),
                          'email': _emailController.text
                        }).eq('id', supabase.auth.currentUser!.id);

                        print("User ID: ${supabase.auth.currentUser!.id}");
                        setState(() {
                          isLoading = false;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/homepage', (route) => false);
                        });
                      }
                    })
                  ],
                );
              }
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:intern_assessment/backend/controller.dart';
import 'package:intern_assessment/component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isValid = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: Theme.of(context).splashColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Component().textfield(context, _emailController, false,
                  decoration: InputDecoration(
                      labelText: "Please enter email to reset password",
                      enabled: !isValid), validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } else if (!Validator().isEmail(value)) {
                  return "Please Enter Valid Email";
                }
                return null;
              }),
              Visibility(
                visible: !isValid,
                child: Component().submitButton(context, "Submit", () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      final data = await supabase
                          .from('user')
                          .select()
                          .eq('email', _emailController.text);

                      if (data.isEmpty || data == []) {
                        throw Exception;
                      }

                      supabase.auth.resetPasswordForEmail(
                        _emailController.text,
                      );
                      print("send OTP");
                      setState(() {
                        isValid = true;
                      });
                    }
                  } catch (e) {
                    print(e.toString());

                    if (context.mounted) {
                      Component()
                          .snackBar(context, "Account don't exist", true);
                    }
                  }
                }),
              ),
              Visibility(
                visible: isValid,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(labelText: "Enter OTP"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Component().submitButton(context, "Submit OTP",
                            () async {
                          try {
                            await supabase.auth.verifyOTP(
                                email: _emailController.text,
                                token: _otpController.text,
                                type: OtpType.recovery);

                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushNamed('/reset_password');
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        }),
                        const SizedBox(
                          width: 10,
                        ),
                        Component().submitButton(context, "Cancel", () async {
                          setState(() {
                            isValid = false;
                          });
                        })
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

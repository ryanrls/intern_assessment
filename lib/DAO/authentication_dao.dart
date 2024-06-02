import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authentication {
  final supabase = Supabase.instance.client;

  Future<void> register(String name, String email, String password) async {
    final res = await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/');

    await supabase.from('user').insert({
      'id': res.user!.id,
      'email': email,
      'name': name,
      'password': password
    });

    print(res.user!.id);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      if (context.mounted) {
        await supabase.auth
            .signInWithPassword(email: email, password: password);
        print('login success');
        Navigator.of(context).pushReplacementNamed('/homepage');
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

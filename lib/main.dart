import 'package:flutter/material.dart';
import 'package:intern_assessment/authentication/forget_password.dart';
import 'package:intern_assessment/authentication/login.dart';
import 'package:intern_assessment/authentication/register.dart';
import 'package:intern_assessment/authentication/reset_password.dart';
import 'package:intern_assessment/todo/Todo.dart';
import 'package:intern_assessment/todo/edit_profile.dart';
import 'package:intern_assessment/todo/homepage.dart';
import 'package:intern_assessment/todo/update_todo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ceivbqjedbcqibqmubzs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlaXZicWplZGJjcWlicW11YnpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcyOTYxOTMsImV4cCI6MjAzMjg3MjE5M30.v8sscPKc7h8exNelq5gViRGINy-C58_SXMQorGSDgIo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/register': (context) => const Register(),
        '/homepage': (context) => const Homepage(),
        '/todo': (context) => const Todo(),
        '/forget_password': (context) => const ForgetPassword(),
        '/reset_password': (context) => const ResetPassword(),
        '/edit_profile': (context) => const EditProfile(),
      },
    );
  }
}

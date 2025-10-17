
import 'package:flutter/material.dart';
import 'package:th2/register_page.dart';
import 'package:th2/otp_verify_page.dart';
import 'package:th2/success_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => const RegisterPage(),
        '/otp': (context) => const OtpVerifyPage(),
        '/success': (context) => const SuccessPage(),
      },
    );
  }
}

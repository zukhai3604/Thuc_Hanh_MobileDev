import 'package:flutter/material.dart';
import 'phan2success.dart';

class EnrollFormPage extends StatefulWidget {
  const EnrollFormPage({super.key});

  @override
  State<EnrollFormPage> createState() => _EnrollFormPageState();
}

class _EnrollFormPageState extends State<EnrollFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v, String field) {
    if (v == null || v.trim().isEmpty) {
      return '$field cannot be blank';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email cannot be blank';
    }
    final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v.trim());
    return ok ? null : 'Enter valid email';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SuccessPage()),
      );
    }
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Enroll User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: _decoration('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: _decoration('Password'),
                obscureText: true,
                validator: (v) => _required(v, 'Password'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameCtrl,
                decoration: _decoration('First Name'),
                validator: (v) => _required(v, 'First Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: _decoration('Last Name'),
                validator: (v) => _required(v, 'Last Name'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('ENROLL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

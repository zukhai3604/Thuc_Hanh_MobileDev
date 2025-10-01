import 'package:flutter/material.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  OutlineInputBorder get _border =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(6));
  OutlineInputBorder get _errorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.red),
  );

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    prefixIcon: const Icon(Icons.person_outline),
    border: _border,
    enabledBorder: _border,
    focusedBorder: _border,
    errorBorder: _errorBorder,
    focusedErrorBorder: _errorBorder,
    // hiển thị giống hình: dòng chữ đỏ dưới ô khi lỗi
    errorStyle: const TextStyle(color: Colors.red),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  String? _require(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  String? _validateEmail(String? v) {
    final empty = _require(v, 'Hãy nhập email');
    if (empty != null) return empty;
    final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v!.trim());
    return ok ? null : 'Email không hợp lệ';
  }

  String? _validatePhone(String? v) {
    final empty = _require(v, 'Hãy nhập điện thoại');
    if (empty != null) return empty;
    final ok = RegExp(r'^\d{9,11}$').hasMatch(v!.trim());
    return ok ? null : 'SĐT 9–11 chữ số';
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ghi thành công!')),
      );
      // Nếu muốn clear:
      // _nameCtrl.clear(); _emailCtrl.clear(); _phoneCtrl.clear();
      // _addressCtrl.clear(); _cityCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập thông tin sinh viên',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade300),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Tiêu đề giống ảnh
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.blue,
              child: const Text(
                'Nhập thông tin sinh viên',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: _decoration('Họ và tên').copyWith(
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                        validator: (v) => _require(v, 'Hãy nhập họ và tên'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: _decoration('Email').copyWith(
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: _decoration('Điện thoại').copyWith(
                          prefixIcon: const Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: _decoration('Địa chỉ').copyWith(
                          prefixIcon: const Icon(Icons.home_outlined),
                        ),
                        validator: (v) => _require(v, 'Hãy nhập địa chỉ'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cityCtrl,
                        decoration: _decoration('Thành phố').copyWith(
                          prefixIcon: const Icon(Icons.location_city_outlined),
                        ),
                        validator: (v) => _require(v, 'Hãy nhập thành phố'),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Ghi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

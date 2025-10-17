
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// label nhỏ nằm TRÊN ô nhập (giống ảnh)
Widget _fieldLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3F3F46),
        ),
      ),
    );

// style InputDecoration thống nhất (bo góc + nền xám nhạt + viền mảnh)
// LƯU Ý: không dùng labelText nữa, chỉ dùng hint để text nằm trong ô
InputDecoration _decoration({
  String? hint,
  Widget? suffixIcon,
}) {
  const radius = 12.0;
  OutlineInputBorder _b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: c, width: 1),
      );

  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF7F7FB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: _b(const Color(0xFFE4E5F0)),
    focusedBorder: _b(Colors.blueAccent),
    errorBorder: _b(Colors.red),
    focusedErrorBorder: _b(Colors.red),
    suffixIcon: suffixIcon,
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender = 'Nam'; // mặc định giống ảnh
  bool _acceptedTerms = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final d = picked.day.toString().padLeft(2, '0');
        final m = picked.month.toString().padLeft(2, '0');
        _dobController.text = "$d/$m/${picked.year}";
      });
    }
  }

  void _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();

    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'fullName': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
      'dob': _dobController.text,
      'gender': _gender,
      'acceptedTerms': _acceptedTerms,
    };

    await prefs.setString('userData', json.encode(userData));

    if (mounted) {
      Navigator.of(context).pushNamed('/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 86,
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đăng Ký Tài Khoản',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Tạo tài khoản để bắt đầu trải nghiệm',
              style: TextStyle(fontSize: 13, color: Color(0xFFE6E6FF)),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.person_add_alt_1_outlined, size: 28),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _fieldLabel('Họ & tên'),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: _decoration(hint: 'Nguyễn Văn A'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Họ & tên không được để trống';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Email'),
                  TextFormField(
                    controller: _emailController,
                    decoration: _decoration(hint: 'example@email.com'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email không được để trống';
                      }
                      final ok = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$')
                          .hasMatch(value.trim());
                      return ok ? null : 'Email không hợp lệ';
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Số điện thoại'),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _decoration(hint: '0987654321'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (!RegExp(r'^\d{10}$').hasMatch(value ?? '')) {
                        return 'Số điện thoại phải gồm 10 chữ số';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Mật khẩu'),
                  _PasswordField(
                    controller: _passwordController,
                    hint: 'Ít nhất 6 ký tự',
                    onValidate: (v) => (v == null || v.length < 6)
                        ? 'Mật khẩu phải có ít nhất 6 ký tự'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Xác nhận mật khẩu'),
                  _PasswordField(
                    controller: _confirmPasswordController,
                    hint: 'Nhập lại mật khẩu',
                    onValidate: (v) =>
                        (v == _passwordController.text) ? null : 'Mật khẩu không khớp',
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Ngày sinh'),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: _decoration(
                      hint: 'dd/mm/yyyy',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn ngày sinh';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- GENDER VALIDATION ---
                  FormField<String>(
                    initialValue: _gender,
                    onSaved: (value) => _gender = value,
                    validator: (value) {
                      if (value == null) return 'Vui lòng chọn giới tính';
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Giới tính'),
                          Column(
                            children: [
                              RadioListTile<String>(
                                dense: true,
                                title: const Text('Nam'),
                                value: 'Nam',
                                groupValue: state.value,
                                onChanged: (v) => state.didChange(v),
                                activeColor: Colors.blueAccent,
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<String>(
                                dense: true,
                                title: const Text('Nữ'),
                                value: 'Nữ',
                                groupValue: state.value,
                                onChanged: (v) => state.didChange(v),
                                activeColor: Colors.blueAccent,
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<String>(
                                dense: true,
                                title: const Text('Khác'),
                                value: 'Khác',
                                groupValue: state.value,
                                onChanged: (v) => state.didChange(v),
                                activeColor: Colors.blueAccent,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 4),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 4),

                  // --- TERMS VALIDATION ---
                  FormField<bool>(
                    initialValue: _acceptedTerms,
                    onSaved: (value) => _acceptedTerms = value ?? false,
                    validator: (value) {
                      if (value == false) {
                        return 'Bạn phải đồng ý với điều khoản sử dụng';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            value: state.value,
                            onChanged: (value) => state.didChange(value),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.blueAccent,
                            contentPadding: EdgeInsets.zero,
                            title: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: const [
                                Text('Tôi đồng ý với'),
                                Text(
                                  'điều khoản sử dụng',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Đăng Ký',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Password field (chỉ dùng hint, label đã đưa ra ngoài) ----
class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final FormFieldValidator<String> onValidate;
  final TextInputAction? textInputAction;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.onValidate,
    this.textInputAction,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: _decoration(
        hint: widget.hint,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      validator: widget.onValidate,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
    );
  }
}

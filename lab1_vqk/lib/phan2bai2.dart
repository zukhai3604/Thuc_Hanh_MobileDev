// lib/bai_rich_text.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RichTextDemo extends StatefulWidget {
  const RichTextDemo({super.key});

  @override
  State<RichTextDemo> createState() => _RichTextDemoState();
}

class _RichTextDemoState extends State<RichTextDemo> {
  bool _expanded = false;

  late TapGestureRecognizer _phoneTap;
  late TapGestureRecognizer _emailTap;
  late TapGestureRecognizer _urlTap;

  @override
  void initState() {
    super.initState();
    _phoneTap = TapGestureRecognizer()
      ..onTap = () => _show('Số điện thoại', '+91000201056');
    _emailTap = TapGestureRecognizer()
      ..onTap = () => _show('Email', 'test@examplemail.org');
    _urlTap = TapGestureRecognizer()
      ..onTap = () => _show('Link', 'https://www.google.com');
  }

  @override
  void dispose() {
    _phoneTap.dispose();
    _emailTap.dispose();
    _urlTap.dispose();
    super.dispose();
  }

  void _show(String label, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bạn đã nhấn $label: $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(color: Colors.black87, height: 1.35, fontSize: 14);
    const blueBold = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w700,
    );
    const link = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header xanh
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.blue,
              child: const Text(
                'Custom Rich Text Example',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .2),
              ),
            ),

            // Card nội dung
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Đoạn mô tả chính
                        RichText(
                          text: TextSpan(
                            style: base,
                            children: const [
                              TextSpan(text: 'Flutter', style: blueBold),
                              TextSpan(
                                  text:
                                      ' is an open-source UI software development kit created by Google. '
                                      'It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. '
                                      'First described in 2015, '),
                              TextSpan(text: 'Flutter', style: blueBold),
                              TextSpan(text: ' was released in May 2017.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Contact: phone + email
                        RichText(
                          text: TextSpan(
                            style: base,
                            children: [
                              const TextSpan(text: 'Contact on '),
                              TextSpan(
                                text: '+91000201056',
                                style: link,
                                recognizer: _phoneTap,
                              ),
                              const TextSpan(text: '. Our email address is '),
                              TextSpan(
                                text: 'test@examplemail.org',
                                style: link,
                                recognizer: _emailTap,
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Link
                        RichText(
                          text: TextSpan(
                            style: base,
                            children: [
                              const TextSpan(text: 'For more details check '),
                              TextSpan(
                                text: 'https://www.google.com',
                                style: link,
                                recognizer: _urlTap,
                              ),
                            ],
                          ),
                        ),

                        // Read more / Read less
                        const SizedBox(height: 8),
                        if (_expanded)
                          const Text(
                            'Flutter dùng Dart, hot reload, và hệ thống widget hiện đại giúp phát triển nhanh, hiệu năng cao trên nhiều nền tảng với một codebase duy nhất.',
                            style: base,
                          ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => setState(() => _expanded = !_expanded),
                          child: Text(
                            _expanded ? 'Read less' : 'Read more',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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

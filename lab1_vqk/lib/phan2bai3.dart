// lib/rich_text_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RichTextScreen extends StatefulWidget {
  const RichTextScreen({super.key});

  @override
  State<RichTextScreen> createState() => _RichTextScreenState();
}

class _RichTextScreenState extends State<RichTextScreen> {
  late TapGestureRecognizer _emailTap;
  late TapGestureRecognizer _phoneTap;
  late TapGestureRecognizer _blogTap;

  @override
  void initState() {
    super.initState();
    _emailTap = TapGestureRecognizer()
      ..onTap = () => _showSnack("Email", "example@email.com");
    _phoneTap = TapGestureRecognizer()
      ..onTap = () => _showSnack("Phone", "+1234987654321");
    _blogTap = TapGestureRecognizer()
      ..onTap = () => _showSnack("Blog", "https://example.com");
  }

  @override
  void dispose() {
    _emailTap.dispose();
    _phoneTap.dispose();
    _blogTap.dispose();
    super.dispose();
  }

  void _showSnack(String title, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bạn đã nhấn $title: $value")),
    );
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(fontSize: 16, color: Colors.black87);
    const linkStyle = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("RichText", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hello World - dòng 1
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Hello ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: "World",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 24,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hello World 👋 - dòng 2
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Hello ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "World ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "👋",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact me via: 📧 Email
            RichText(
              text: TextSpan(
                style: baseStyle,
                children: [
                  const TextSpan(text: "Contact me via: "),
                  WidgetSpan(
                    child: Icon(Icons.email, size: 18, color: Colors.blue),
                  ),
                  const WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(
                    text: "Email",
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    recognizer: _emailTap,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Call Me: +1234987654321
            RichText(
              text: TextSpan(
                style: baseStyle,
                children: [
                  const TextSpan(
                    text: "Call Me: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "+1234987654321",
                    style: linkStyle,
                    recognizer: _phoneTap,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Read My Blog HERE
            RichText(
              text: TextSpan(
                style: baseStyle,
                children: [
                  const TextSpan(
                    text: "Read My Blog ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "HERE",
                    style: linkStyle,
                    recognizer: _blogTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

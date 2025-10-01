import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDemoPage(),
    );
  }
}

class GestureDemoPage extends StatelessWidget {
  const GestureDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Demo Gestures in Flutter',
          style: TextStyle(
            color: Colors.white,   // màu chữ
            fontSize: 20,          // cỡ chữ
          ),
        ),
        backgroundColor: Colors.blue, // màu nền AppBar
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Chạm vào hình giữ và kéo hoặc zoom',
              style: TextStyle(
                fontSize: 30, // tăng cỡ chữ

              ),
            ),

          ),
          Expanded(
            child: SizedBox.expand(
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                // Cho phép kéo tự do khắp màn
                constrained: false,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.5,
                maxScale: 4.0,
                child: Align(
                  alignment: Alignment.topCenter, // <-- thêm dấu phẩy ở đây
                  child: ClipOval(
                    child: Image.network(
                      'https://picsum.photos/300',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

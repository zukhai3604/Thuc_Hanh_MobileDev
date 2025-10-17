import 'package:flutter/material.dart';
// import 'bai1.dart';
// import 'bai2.dart';
// import 'bai3.dart';
// import 'bai4.dart';
// import 'bai5.dart';
// import 'phan2bai1.dart';
//import 'phan2bai2.dart';
//import 'phan2bai3.dart';
import 'phan2bai4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTTH Flutter',
      debugShowCheckedModeBanner: false,
      //home: ExampleButtons(), // gọi thẳng vào Bài 1
      //home: MyHomePage(title: 'Hồ sơ giảng viên'),
      //home: BoxGame(title: 'BÔNG TUYẾT MAY MẮN'),
      //home: Exercise04(),
      //home: Exercise05(),
      //home: ProductListPage(),
      //home: RichTextDemo(),
      //home: const RichTextScreen(),
      home: AppButtonsScreen(),
    );
  }
}

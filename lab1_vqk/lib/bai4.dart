import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Hằng số dùng lại
const TextStyle kStyleProject =
TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Exercise04-lab09",
      debugShowCheckedModeBanner: false,
      home: Exercise04(),
    );
  }
}

class Exercise04 extends StatelessWidget {
  const Exercise04({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    width: deviceWidth,
                    height: 200,
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0)),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'CHIM CÁNH CỤT',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        Text(
                          'Flutter Software Engineer',
                          style:
                          TextStyle(fontSize: 20.0, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage:
                      AssetImage("assets/images/chimcanhcut.jpg"),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _SmallBoxImage(),
                _SmallBoxImage(),
                _SmallBoxImage(),
                _SmallBoxImage(),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text("125", style: kStyleProject), Text("Projects")]),
                Column(children: [Text("185", style: kStyleProject), Text("Following")]),
                Column(children: [Text("1428", style: kStyleProject), Text("Follower")]),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: kStyleProject),
                  SizedBox(height: 10),
                  Text(
                    "is simply dummy text of the printing and typesetting industry. "
                        "Lorem Ipsum has been the industry's standard dummy text ever "
                        "since the 1500s ...",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('View Detail')),
                ElevatedButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SingleChildScrollView(
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _WideBoxImage(),
                  _WideBoxImage(),
                  _WideBoxImage(),
                  _WideBoxImage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ảnh nhỏ 80px lặp lại phía trên
class _SmallBoxImage extends StatelessWidget {
  const _SmallBoxImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/boxmagic.png", width: 80);
  }
}

/// Ảnh ngang 180px trong danh sách ngang
class _WideBoxImage extends StatelessWidget {
  const _WideBoxImage();

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/images/boxmagic.png'),
      width: 180,
    );
  }
}

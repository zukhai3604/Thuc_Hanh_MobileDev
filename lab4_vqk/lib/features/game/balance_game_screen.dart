// lib/features/game/balance_game_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BalanceGameScreen extends StatefulWidget {
  const BalanceGameScreen({super.key});

  @override
  State<BalanceGameScreen> createState() => _BalanceGameScreenState();
}

class _BalanceGameScreenState extends State<BalanceGameScreen> {
  static const double ballSize = 50;
  static const double targetSize = 60;

  double ballX = 100, ballY = 100;
  double targetX = 200, targetY = 400;

  double vx = 0, vy = 0;       // vận tốc “ảo” để làm mượt
  final double accelScale = 4; // độ nhạy nghiêng
  final double damping = 0.9;  // ma sát

  StreamSubscription<AccelerometerEvent>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEvents.listen((e) {
      vx += (-e.x) * accelScale; // trái/phải
      vy += (e.y) * accelScale;  // trước/sau
      setState(() {
        vx *= damping;
        vy *= damping;
        ballX += vx * 0.016; // ~16ms/frame
        ballY += vy * 0.016;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _clampInBounds(Size size) {
    ballX = ballX.clamp(0, size.width - ballSize);
    ballY = ballY.clamp(0, size.height - ballSize);
  }

  bool _checkWin() {
    final bx = ballX + ballSize / 2;
    final by = ballY + ballSize / 2;
    final tx = targetX + targetSize / 2;
    final ty = targetY + targetSize / 2;
    final dist = sqrt(pow(bx - tx, 2) + pow(by - ty, 2));
    return dist <= (targetSize / 2);
  }

  void _randomizeTarget(Size size) {
    final rnd = Random();
    targetX = rnd.nextDouble() * (size.width - targetSize);
    targetY = rnd.nextDouble() * (size.height - targetSize - 100) + 100; // chừa appbar
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _clampInBounds(Size(c.maxWidth, c.maxHeight));
          if (_checkWin()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Chiến thắng!')));
            _randomizeTarget(Size(c.maxWidth, c.maxHeight));
          }
        });
      });

      return Scaffold(
        appBar: AppBar(
          title: const Text('Lăn bi'),
          actions: [
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () {
                setState(() {
                  ballX = 100; ballY = 100; vx = 0; vy = 0;
                  _randomizeTarget(Size(c.maxWidth, c.maxHeight));
                });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              left: targetX,
              top: targetY,
              child: Container(
                width: targetSize,
                height: targetSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 5),
                ),
              ),
            ),
            Positioned(
              left: ballX,
              top: ballY,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// lib/features/survey/survey_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';

import 'survey_model.dart';
import 'survey_store.dart';
import 'color_mappers.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});
  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // Sensors
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;

  // Light sensor
  Light? _light; // <-- THÊM DÒNG NÀY
  StreamSubscription<int>? _lightSub;

  // Latest values
  double _ax = 0, _ay = 0, _az = 0;
  double _mx = 0, _my = 0, _mz = 0;
  double _lightLux = -1; // -1 => n/a

  // Smoothing
  final double _accelAlpha = 0.2;
  final double _magAlpha = 0.2;

  @override
  void initState() {
    super.initState();
    _initPermissions();
    _listenSensors();
    _listenLight(); // đọc lux
  }

  /// Xin quyền & bật dịch vụ vị trí bằng package `location`
  Future<void> _initPermissions() async {
    final location = Location();

    // Bật dịch vụ vị trí nếu đang tắt
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hãy bật dịch vụ vị trí.')),
        );
        return;
      }
    }

    // Xin quyền vị trí
    var perm = await location.hasPermission();
    if (perm == PermissionStatus.denied) {
      perm = await location.requestPermission();
    }
    if (perm == PermissionStatus.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền vị trí bị từ chối vĩnh viễn. Mở trong Cài đặt để cấp lại.')),
      );
    } else if (perm != PermissionStatus.granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiếu quyền vị trí.')),
      );
    }
  }

  void _listenSensors() {
    _accelSub = accelerometerEvents.listen((e) {
      if (!mounted) return;
      setState(() {
        _ax = _ax + _accelAlpha * (e.x - _ax);
        _ay = _ay + _accelAlpha * (e.y - _ay);
        _az = _az + _accelAlpha * (e.z - _az);
      });
    }, onError: (_) {});

    _magSub = magnetometerEvents.listen((e) {
      if (!mounted) return;
      setState(() {
        _mx = _mx + _magAlpha * (e.x - _mx);
        _my = _my + _magAlpha * (e.y - _my);
        _mz = _mz + _magAlpha * (e.z - _mz);
      });
    }, onError: (_) {});
  }

  void _listenLight() {
    try {
      _light = Light(); // Tạo instance mới của cảm biến ánh sáng
      _lightSub = _light!.lightSensorStream.listen(
            (int lux) {
          if (!mounted) return;
          setState(() {
            _lightLux = lux.toDouble();
          });
        },
        onError: (Object e) {
          // Nếu thiết bị không có cảm biến hoặc lỗi khi đọc
          if (!mounted) return;
          setState(() {
            _lightLux = -1;
          });
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Khi khởi tạo Light() thất bại (ví dụ: emulator, thiết bị không hỗ trợ)
      if (!mounted) return;
      setState(() {
        _lightLux = -1;
      });
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _magSub?.cancel();
    _lightSub?.cancel();
    super.dispose();
  }

  double get _accelMag => sqrt(_ax * _ax + _ay * _ay + _az * _az);
  double get _magMag => sqrt(_mx * _mx + _my * _my + _mz * _mz);

  Future<void> _recordPoint() async {
    try {
      final location = Location();
      final pos = await location.getLocation();

      final rec = SurveyRecord(
        latitude: pos.latitude ?? 0,
        longitude: pos.longitude ?? 0,
        lightLux: _lightLux,
        accelMag: _accelMag,
        magField: _magMag,
        timestamp: DateTime.now(),
      );
      await SurveyStore.append(rec);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã ghi dữ liệu!')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không thể lấy vị trí hiện tại.')));
    }
  }

  Widget _sensorTile(IconData icon, String label, String value, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightDisplay = _lightLux >= 0 ? '${_lightLux.toStringAsFixed(0)} lux' : 'n/a';

    return Scaffold(
      appBar: AppBar(title: const Text('Trạm Khảo sát')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _sensorTile(
              Icons.wb_sunny,
              'Cường độ Ánh sáng',
              lightDisplay,
              lightColor(_lightLux < 0 ? 0 : _lightLux),
            ),
            _sensorTile(
              Icons.directions_walk,
              'Độ "Năng động" (|a|)',
              _accelMag.toStringAsFixed(2),
              accelColor(_accelMag),
            ),
            _sensorTile(
              Icons.explore, // tương thích mọi SDK
              'Cường độ Từ trường (|B|)',
              '${_magMag.toStringAsFixed(2)} µT (xấp xỉ)',
              magneticColor(_magMag),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_location_alt),
                label: const Text('Ghi Dữ liệu tại Điểm này'),
                onPressed: _recordPoint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

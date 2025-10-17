import 'package:flutter/material.dart';
import '../survey/survey_store.dart';
import '../survey/survey_model.dart';
import '../survey/color_mappers.dart';

class DataMapScreen extends StatefulWidget {
  const DataMapScreen({super.key});
  @override
  State<DataMapScreen> createState() => _DataMapScreenState();
}

class _DataMapScreenState extends State<DataMapScreen> {
  List<SurveyRecord> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SurveyStore.readAll();
    data.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    setState(() => _items = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ Dữ liệu'),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('Chưa có bản ghi.'))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final e = _items[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text('(${e.latitude.toStringAsFixed(6)}, ${e.longitude.toStringAsFixed(6)})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: lightColor(e.lightLux < 0 ? 0 : e.lightLux)),
                      const SizedBox(width: 6),
                      Text(e.lightLux >= 0 ? '${e.lightLux.toStringAsFixed(0)} lux' : 'n/a'),
                      const SizedBox(width: 16),
                      Icon(Icons.directions_walk, color: accelColor(e.accelMag)),
                      const SizedBox(width: 6),
                      Text('|a|=${e.accelMag.toStringAsFixed(2)}'),
                      const SizedBox(width: 16),
                      Icon(Icons.explore, color: magneticColor(e.magField)),
                      const SizedBox(width: 6),
                      Text('|B|=${e.magField.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Thời gian: ${e.timestamp}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

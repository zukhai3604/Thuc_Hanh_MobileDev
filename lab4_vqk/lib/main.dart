import 'package:flutter/material.dart';
import 'features/survey/survey_screen.dart';
import 'features/data_map/data_map_screen.dart';
import 'features/game/balance_game_screen.dart';

void main() {
  runApp(const SchoolYardApp());
}

class SchoolYardApp extends StatelessWidget {
  const SchoolYardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTTH04 - Sensors',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routes: {
        '/': (_) => const HomeScreen(),
        '/survey': (_) => const SurveyScreen(),
        '/data': (_) => const DataMapScreen(),
        '/game': (_) => const BalanceGameScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BTTH04 - Sensors')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('Trạm Khảo sát'),
              onTap: () => Navigator.pushNamed(context, '/survey'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Bản đồ Dữ liệu'),
              onTap: () => Navigator.pushNamed(context, '/data'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.sports_baseball),
              title: const Text('Game Lăn bi'),
              onTap: () => Navigator.pushNamed(context, '/game'),
            ),
          ],
        ),
      ),
    );
  }
}

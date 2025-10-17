import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'survey_model.dart';

class SurveyStore {
  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${SurveyFile.fileName}');
  }

  static Future<List<SurveyRecord>> readAll() async {
    final f = await _file();
    if (!await f.exists()) return [];
    final raw = await f.readAsString();
    return SurveyFile.decodeList(raw);
  }

  static Future<void> append(SurveyRecord record) async {
    final existing = await readAll();
    existing.add(record);
    final f = await _file();
    await f.writeAsString(SurveyFile.encodeList(existing));
  }
}

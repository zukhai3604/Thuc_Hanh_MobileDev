
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:b2th2/models/address.dart';

class VnAdminLoader {
  Future<List<Province>> loadProvinces() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/vn_admin.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final provincesList = data['provinces'] as List;
      return provincesList.map((p) => Province.fromJson(p as Map<String, dynamic>)).toList();
    } catch (e) {
      // In a real app, you might want to handle this error more gracefully.
      // For this example, we'll just print the error and return an empty list.
      print('Error loading provinces: $e');
      return [];
    }
  }
}

// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'product.dart';

class ApiService {
  /// Tự chọn baseUrl theo nền tảng.
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';             // Flutter Web/desktop
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';                        // Android emulator
    }
    return 'http://127.0.0.1:8000/api';                         // iOS simulator / desktop
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/products'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => Product.fromJson(e)).toList();
      }
      throw Exception('Fetch failed (${res.statusCode}): ${res.body}');
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final res = await http.put( // hoặc http.patch
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (res.statusCode == 200) { // 200: OK
        return Product.fromJson(jsonDecode(res.body));
      }

      if (res.statusCode == 422) {
        final body = jsonDecode(res.body);
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw Exception('Lỗi: $firstError');
      }

      throw Exception('Cập nhật thất bại (${res.statusCode}): ${res.body}');
    } catch (e) {
      rethrow;
    }
  }
  Future<Product> createProduct(Product product) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      // Xử lý các trường hợp status code
      if (res.statusCode == 201) { // 201: Created
        return Product.fromJson(jsonDecode(res.body));
      }

      if (res.statusCode == 422) { // 422: Lỗi validation từ Laravel
        final body = jsonDecode(res.body);
        // Lấy message lỗi cho thân thiện hơn
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw Exception('Lỗi: $firstError');
      }

      // Ném lỗi cho các trường hợp thất bại khác
      throw Exception('Tạo sản phẩm thất bại (${res.statusCode}): ${res.body}');
    } catch (e) {
      // Ném lại lỗi để UI có thể bắt được
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/products/$id'));
      if (res.statusCode != 204 && res.statusCode != 200) {
        throw Exception('Delete failed (${res.statusCode}): ${res.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}

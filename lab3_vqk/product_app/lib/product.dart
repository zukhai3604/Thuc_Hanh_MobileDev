import 'category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String?,
    price: (json['price'] is String)
        ? double.parse(json['price'])
        : (json['price'] as num).toDouble(),
    category: json['category'] == null ? null : Category.fromJson(json['category']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'category_id': category?.id, // gửi id khi tạo/sửa
  };
}

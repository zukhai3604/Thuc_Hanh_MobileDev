class Category {
  final int id;
  final String name;
  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> j) =>
      Category(id: j['id'] as int, name: j['name'] as String);
}

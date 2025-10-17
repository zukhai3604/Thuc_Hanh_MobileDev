
import 'package:flutter/material.dart';


class Product {
  final String title;
  final int price;
  final double rating;
  final String viewsText;
  final String imageUrl;

  const Product({
    required this.title,
    required this.price,
    required this.rating,
    required this.viewsText,
    required this.imageUrl,
  });
}

// ---- Trang danh sách sản phẩm ----
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  // Data mẫu (ảnh mạng — không cần thêm assets)
  final List<Product> products = const [
    Product(
      title: "Ví nam mini đựng thẻ VS22 chất da Saffiano bền đẹp chống xước",
      price: 255000,
      rating: 4.0,
      viewsText: "12 views",
      imageUrl:
      "https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?q=80&w=800&auto=format&fit=crop",
    ),
    Product(
      title: "Túi đeo chéo LEACAT polyester chống thấm nước thời trang công sở",
      price: 315000,
      rating: 5.0,
      viewsText: "1.3k views",
      imageUrl:
      "https://images.unsplash.com/photo-1547949003-9792a18a2601?q=80&w=800&auto=format&fit=crop",
    ),
    Product(
      title: "Phin cafe Trung Nguyên - Phin nhôm cỡ nhỡ cao cấp",
      price: 82000,
      rating: 4.5,
      viewsText: "12.2k views",
      imageUrl:
      "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800&auto=format&fit=crop",
    ),
    Product(
      title: "Ví đeo cầm tay nam kiểu cổ điển thiết kế thời trang cho nam",
      price: 610000,
      rating: 5.0,
      viewsText: "56 views",
      imageUrl:
      "https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=800&auto=format&fit=crop",
    ),
    Product(
      title: "Dép đế cao nữ đế bánh mì êm chân dạo phố",
      price: 199000,
      rating: 4.3,
      viewsText: "2.1k views",
      imageUrl:
      "https://images.unsplash.com/photo-1560343090-f0409e92791a?q=80&w=800&auto=format&fit=crop",
    ),
    Product(
      title: "Tai nghe TWS M10 âm trầm mạnh mẽ, kèm hộp sạc",
      price: 159000,
      rating: 4.8,
      viewsText: "9.8k views",
      imageUrl:
      "https://images.unsplash.com/photo-1518442329349-87cb7f89d3d5?q=80&w=800&auto=format&fit=crop",
    ),
  ];

  String _priceVND(int value) {
    final s = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => '.',
    );
    return "$s VND";
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // <<<< THÊM SAFEAREA Ở ĐÂY
        child: Column(
          children: [
            // Thanh tiêu đề xanh giống ảnh
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.blue,
              child: const Text(
                "DANH SÁCH SẢN PHẨM",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            // Lưới sản phẩm
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.78, // chỉnh tỉ lệ cho giống ảnh
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Card(
                    elevation: 1.5,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            p.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        ),

                        // Nội dung
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Hàng: giá + views
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                _priceVND(p.price),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.visibility,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                p.viewsText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Hàng: Badge + rating
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Row(
                            children: [
                              _badge("MẪU MỚI", Colors.deepOrange),
                              const SizedBox(width: 4),
                              _badge("JTRA", Colors.blue),
                              const Spacer(),
                              const Icon(Icons.star,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 2),
                              Text(
                                p.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'product.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ProductListScreen(),
    );
  }
}

//==============================================================================
// Màn hình danh sách sản phẩm
//==============================================================================
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final api = ApiService();

  List<Product> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await api.fetchProducts();
      setState(() => _items = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _gotoAdd() async {
    final created = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (created != null) {
      setState(() => _items = [created, ..._items]);
      _showSnack('Đã thêm sản phẩm "${created.name}"');
    }
  }

  Future<void> _delete(Product p, int index) async {
    final backup = p;
    setState(() => _items.removeAt(index));

    try {
      await api.deleteProduct(p.id);
      _showSnack('Đã xóa "${p.name}"');
    } catch (e) {
      setState(() => _items.insert(index, backup));
      _showSnack('Xóa thất bại: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lỗi: $_error'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _fetch, child: const Text('Thử lại')),
          ],
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: _fetch,
        child: _items.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: Text('Chưa có sản phẩm nào')),
          ],
        )
            : ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = _items[i];
            return ListTile(
              title: Text(p.name),
              subtitle: Text(p.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${p.price.toStringAsFixed(2)}'),
                  //-- Nút Edit --
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updated = await Navigator.push<Product>(
                        context,
                        MaterialPageRoute(builder: (_) => EditProductScreen(product: p)),
                      );
                      if (updated != null) {
                        setState(() {
                          final idx = _items.indexWhere((e) => e.id == updated.id);
                          if (idx != -1) _items[idx] = updated;
                        });
                        _showSnack('Đã cập nhật "${updated.name}"');
                      }
                    },
                  ),
                  //-- Nút Delete --
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Xóa sản phẩm?'),
                          content: Text('Bạn chắc chắn muốn xóa "${p.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Hủy'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await _delete(p, i);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách sản phẩm')),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

//==============================================================================
// Màn hình thêm sản phẩm
//==============================================================================
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final api = ApiService();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      final p = Product(
        id: 0,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
      );
      final created = await api.createProduct(p);
      if (!mounted) return;
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sản phẩm')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Vui lòng nhập tên';
                if (v.trim().length > 255) return 'Tên quá dài';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Mô tả (tùy chọn)', border: OutlineInputBorder()),
              maxLines: 3,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v != null && v.trim().length > 500) return 'Mô tả tối đa 500 ký tự';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceCtrl,
              decoration: const InputDecoration(labelText: 'Giá', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onEditingComplete: _submit,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Vui lòng nhập giá';
                final value = double.tryParse(v.trim());
                if (value == null) return 'Giá không hợp lệ';
                if (value < 0) return 'Giá phải ≥ 0';
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

//==============================================================================
// Màn hình sửa sản phẩm
//==============================================================================
class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _descCtrl, _priceCtrl;
  final api = ApiService();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.name);
    _descCtrl = TextEditingController(text: widget.product.description ?? '');
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // **** PHẦN SỬA LỖI BẮT ĐẦU TỪ ĐÂY ****

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final p = Product(
        id: widget.product.id,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
      );
      final updated = await api.updateProduct(widget.product.id, p);
      if (!mounted) return;
      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa sản phẩm')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm', border: OutlineInputBorder()),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nhập tên';
                if (v.trim().length > 255) return 'Tên quá dài';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Mô tả (tùy chọn)', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (v) {
                if (v != null && v.trim().length > 500) return 'Tối đa 500 ký tự';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceCtrl,
              decoration: const InputDecoration(labelText: 'Giá', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nhập giá';
                final value = double.tryParse(v.trim());
                if (value == null) return 'Giá không hợp lệ';
                if (value < 0) return 'Giá phải ≥ 0';
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
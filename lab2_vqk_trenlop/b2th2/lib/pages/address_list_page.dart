
import 'package:b2th2/models/address.dart';
import 'package:b2th2/services/address_store.dart';
import 'package:flutter/material.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final AddressStore _addressStore = AddressStore();
  List<Address> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final addresses = await _addressStore.loadAddresses();
    setState(() {
      _addresses = addresses;
      _isLoading = false;
    });
  }

  void _navigateAndRefresh(String routeName, {Object? arguments}) async {
    final result = await Navigator.pushNamed(context, routeName, arguments: arguments);
    // Reload addresses if we are coming back from the form or map
    if (result == true || result == null) { // result can be null if user just backs out
      _loadAddresses();
    }
  }

  Future<void> _deleteAddress(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa địa chỉ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _addresses.removeWhere((a) => a.id == id);
      await _addressStore.saveAddresses(_addresses);
      _loadAddresses(); // to refresh the state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ của tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm địa chỉ',
            onPressed: () => _navigateAndRefresh('/address_form'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? const Center(
                  child: Text(
                  'Chưa có địa chỉ nào được lưu.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.recipientName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${address.phone} • ${address.province.name}, ${address.district.name}, ${address.ward.name}'),
                            const SizedBox(height: 4),
                            Text(address.addressDetails),
                            if (address.location != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${address.location!.latitude.toStringAsFixed(5)}, ${address.location!.longitude.toStringAsFixed(5)}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _navigateAndRefresh('/address_form', arguments: address),
                                  child: const Text('Sửa'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => _deleteAddress(address.id),
                                  child: Text(
                                    'Xóa',
                                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

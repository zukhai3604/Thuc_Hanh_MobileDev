
import 'package:b2th2/data/vn_admin_loader.dart';
import 'package:b2th2/models/address.dart';
import 'package:b2th2/services/address_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class AddressFormPage extends StatefulWidget {
  final Address? addressToEdit;

  const AddressFormPage({super.key, this.addressToEdit});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _detailsController = TextEditingController();

  final _vnAdminLoader = VnAdminLoader();
  final _addressStore = AddressStore();

  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Ward> _wards = [];

  Province? _selectedProvince;
  District? _selectedDistrict;
  Ward? _selectedWard;
  LatLng? _selectedLocation;

  bool get _isEditing => widget.addressToEdit != null;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    if (_isEditing) {
      _prefillForm();
    }
  }

  Future<void> _loadAdminData() async {
    final provinces = await _vnAdminLoader.loadProvinces();
    setState(() {
      _provinces = provinces;
    });

    // If editing, we need to make sure the lists are correctly populated
    if (_isEditing && _provinces.isNotEmpty) {
      final preselectedProvince = _provinces.firstWhere(
        (p) => p.code == widget.addressToEdit!.province.code,
      );
      final preselectedDistrict = preselectedProvince.districts
          .firstWhere((d) => d.code == widget.addressToEdit!.district.code);

      setState(() {
        _selectedProvince = preselectedProvince;
        _districts = preselectedProvince.districts;
        _selectedDistrict = preselectedDistrict;
        _wards = preselectedDistrict.wards;
        _selectedWard = _wards.firstWhere((w) => w.code == widget.addressToEdit!.ward.code);
      });
    }
  }

  void _prefillForm() {
    final address = widget.addressToEdit!;
    _nameController.text = address.recipientName;
    _phoneController.text = address.phone;
    _detailsController.text = address.addressDetails;
    _selectedLocation = address.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _onProvinceChanged(Province? province) {
    if (province == null) return;
    setState(() {
      _selectedProvince = province;
      _districts = province.districts;
      _selectedDistrict = null;
      _wards = [];
      _selectedWard = null;
    });
  }

  void _onDistrictChanged(District? district) {
    if (district == null) return;
    setState(() {
      _selectedDistrict = district;
      _wards = district.wards;
      _selectedWard = null;
    });
  }

  void _onWardChanged(Ward? ward) {
    if (ward == null) return;
    setState(() {
      _selectedWard = ward;
    });
  }

  Future<void> _pickLocationOnMap() async {
    final location = await Navigator.pushNamed(
      context,
      '/map_picker',
      arguments: _selectedLocation,
    ) as LatLng?;

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newOrUpdatedAddress = Address(
      id: _isEditing ? widget.addressToEdit!.id : const Uuid().v4(),
      recipientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      province: _selectedProvince!,
      district: _selectedDistrict!,
      ward: _selectedWard!,
      addressDetails: _detailsController.text.trim(),
      location: _selectedLocation,
    );

    final addresses = await _addressStore.loadAddresses();
    if (_isEditing) {
      final index = addresses.indexWhere((a) => a.id == newOrUpdatedAddress.id);
      if (index != -1) {
        addresses[index] = newOrUpdatedAddress;
      }
    } else {
      addresses.add(newOrUpdatedAddress);
    }

    await _addressStore.saveAddresses(addresses);

    if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ mới'),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          TextButton(
            onPressed: _saveAddress,
            child: const Text('Lưu địa chỉ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Tên người nhận'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nhập tên...'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tên người nhận không được để trống' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Số điện thoại'),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(hintText: 'Nhập số điện thoại'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                validator: (v) => (v == null || v.length != 10) ? 'Số điện thoại phải gồm 10 chữ số' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Tỉnh / Thành phố'),
              _buildDropdown<Province>(
                value: _selectedProvince,
                items: _provinces,
                hint: 'Chọn Tỉnh/Thành phố',
                onChanged: _onProvinceChanged,
                validator: (v) => v == null ? 'Vui lòng chọn Tỉnh/Thành phố' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Quận / Huyện'),
              _buildDropdown<District>(
                value: _selectedDistrict,
                items: _districts,
                hint: 'Chọn Quận/Huyện',
                onChanged: _onDistrictChanged,
                validator: (v) => v == null ? 'Vui lòng chọn Quận/Huyện' : null,
                enabled: _selectedProvince != null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Phường / Xã'),
              _buildDropdown<Ward>(
                value: _selectedWard,
                items: _wards,
                hint: 'Chọn Phường/Xã',
                onChanged: _onWardChanged,
                validator: (v) => v == null ? 'Vui lòng chọn Phường/Xã' : null,
                enabled: _selectedDistrict != null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Địa chỉ chi tiết'),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(hintText: 'Số nhà, tên đường, tòa nhà...'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập địa chỉ chi tiết' : null,
              ),
              const SizedBox(height: 24),
              _buildLabel('Vị trí trên bản đồ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _pickLocationOnMap,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Chọn trên bản đồ'),
                  ),
                  Text(
                    _selectedLocation == null
                        ? 'Chưa chọn vị trí'
                        : 'Đã chọn: ${(_selectedLocation!.latitude).toStringAsFixed(4)}, ${(_selectedLocation!.longitude).toStringAsFixed(4)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDropdown<T>({T? value, required List<T> items, required String hint, required ValueChanged<T?> onChanged, FormFieldValidator<T>? validator, bool enabled = true}) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        String name = '';
        if (item is Province) name = item.name;
        if (item is District) name = item.name;
        if (item is Ward) name = item.name;
        return DropdownMenuItem<T>(value: item, child: Text(name));
      }).toList(),
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(hintText: hint, filled: !enabled, fillColor: Colors.grey[200]),
      validator: validator,
      isExpanded: true,
    );
  }
}


import 'dart:convert';
import 'package:b2th2/models/address.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressStore {
  static const String _storageKey = "addresses";

  Future<List<Address>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressesJson = prefs.getString(_storageKey);

    if (addressesJson != null) {
      try {
        final List<dynamic> decodedList = json.decode(addressesJson) as List;
        return decodedList
            .map((item) => Address.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Handle potential parsing errors, maybe return an empty list
        // or log the error.
        print('Error decoding addresses: $e');
        return [];
      }
    } else {
      // Return an empty list if no addresses are stored yet.
      return [];
    }
  }

  Future<void> saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> encodedList =
        addresses.map((address) => address.toJson()).toList();
    final String addressesJson = json.encode(encodedList);
    await prefs.setString(_storageKey, addressesJson);
  }
}

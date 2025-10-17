
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final String id;
  final String recipientName;
  final String phone;
  final Province province;
  final District district;
  final Ward ward;
  final String addressDetails;
  final LatLng? location;

  Address({
    required this.id,
    required this.recipientName,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.addressDetails,
    this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      recipientName: json['recipientName'] as String,
      phone: json['phone'] as String,
      province: Province.fromJson(json['province'] as Map<String, dynamic>),
      district: District.fromJson(json['district'] as Map<String, dynamic>),
      ward: Ward.fromJson(json['ward'] as Map<String, dynamic>),
      addressDetails: json['addressDetails'] as String,
      location: json['location'] != null
          ? LatLng(
              (json['location']['lat'] as num).toDouble(),
              (json['location']['lng'] as num).toDouble(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'phone': phone,
      'province': province.toJson(),
      'district': district.toJson(),
      'ward': ward.toJson(),
      'addressDetails': addressDetails,
      'location': location != null
          ? {'lat': location!.latitude, 'lng': location!.longitude}
          : null,
    };
  }

  Address copyWith({
    String? id,
    String? recipientName,
    String? phone,
    Province? province,
    District? district,
    Ward? ward,
    String? addressDetails,
    LatLng? location,
  }) {
    return Address(
      id: id ?? this.id,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      addressDetails: addressDetails ?? this.addressDetails,
      location: location ?? this.location,
    );
  }
}

class Province {
  final String code;
  final String name;
  final List<District> districts;

  Province({required this.code, required this.name, this.districts = const []});

  factory Province.fromJson(Map<String, dynamic> json) {
    var districtList = (json['districts'] as List?)
        ?.map((d) => District.fromJson(d as Map<String, dynamic>))
        .toList();

    return Province(
      code: json['code'] as String,
      name: json['name'] as String,
      districts: districtList ?? [],
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'name': name};
}

class District {
  final String code;
  final String name;
  final List<Ward> wards;

  District({required this.code, required this.name, this.wards = const []});

  factory District.fromJson(Map<String, dynamic> json) {
    var wardList = (json['wards'] as List?)
        ?.map((w) => Ward.fromJson(w as Map<String, dynamic>))
        .toList();
    return District(
      code: json['code'] as String,
      name: json['name'] as String,
      wards: wardList ?? [],
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'name': name};
}

class Ward {
  final String code;
  final String name;

  Ward({required this.code, required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'name': name};
}

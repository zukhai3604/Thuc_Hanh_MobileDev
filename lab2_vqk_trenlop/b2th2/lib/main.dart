
import 'package:b2th2/models/address.dart';
import 'package:b2th2/pages/address_form_page.dart';
import 'package:b2th2/pages/address_list_page.dart';
import 'package:b2th2/pages/map_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Address App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B61F6)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5B61F6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF5B61F6)),
          ),
        ),
      ),
      initialRoute: '/addresses',
      routes: {
        '/addresses': (context) => const AddressListPage(),
        '/address_form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return AddressFormPage(addressToEdit: args as Address?);
        },
        '/map_picker': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as LatLng?;
            return MapPickerPage(initialLocation: args);
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

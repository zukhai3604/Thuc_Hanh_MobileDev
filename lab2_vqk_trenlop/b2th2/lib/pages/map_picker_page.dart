
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  static const _defaultInitialLocation = LatLng(16.047079, 108.206230); // Da Nang

  late GoogleMapController _mapController;
  late LatLng _currentPinLocation;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPinLocation = widget.initialLocation ?? _defaultInitialLocation;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentPinLocation = position.target;
    });
  }

  Future<void> _searchAndGo() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      final locations = await geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 15.0,
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy địa điểm.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn vị trí trên bản đồ'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPinLocation,
              zoom: 14.0,
            ),
            onCameraMove: _onCameraMove,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false, // Controls are added manually
          ),
          // Center Pin
          const Center(
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 50,
            ),
          ),
          // UI Controls
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: _buildSearchCard(),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: _buildConfirmationCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm địa điểm...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _searchAndGo(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchAndGo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Vị trí đã chọn: ${_currentPinLocation.latitude.toStringAsFixed(5)}, ${_currentPinLocation.longitude.toStringAsFixed(5)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_currentPinLocation);
                  },
                  child: const Text('Xác nhận vị trí'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

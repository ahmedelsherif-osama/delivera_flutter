import 'package:delivera_flutter/features/utils/location_service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final apiKey = dotenv.env['MAPTILER_API_KEY'];
  final MapController _mapController = MapController();

  LatLng? _selected;
  LatLng _center = LatLng(30.05, 31.237);
  double _zoom = 13;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final service = LocationService();
    final result = await service.getCurrentLocation();

    result.fold(
      (pos) {
        setState(() {
          _center = pos;
          _selected = pos;
        });
        _mapController.move(pos, _zoom);
      },
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to fetch current location")),
        );
      },
    );
  }

  void _handleTap(TapPosition tap, LatLng latLng) {
    setState(() {
      _selected = latLng;
      _center = latLng;
    });
  }

  void _confirm() {
    if (_selected != null) {
      Navigator.of(context).pop(_selected);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tap on the map to select a point")),
      );
    }
  }

  void _zoomIn() {
    setState(() {
      _zoom += 1;
      _mapController.move(_center, _zoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom -= 1;
      _mapController.move(_center, _zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _zoom,
              onTap: _handleTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey',
                userAgentPackageName: 'com.example.delivera_flutter',
              ),
              if (_selected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Floating map controls
          Positioned(
            right: 15,
            top: 20,
            child: Column(
              children: [
                _MapIconButton(icon: Icons.add, onPressed: _zoomIn),
                const SizedBox(height: 10),
                _MapIconButton(icon: Icons.remove, onPressed: _zoomOut),
                const SizedBox(height: 10),
                _MapIconButton(
                  icon: Icons.my_location,
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _confirm,
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
            ),
          ),

          // Optional: small coordinate preview
          if (_selected != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Selected: ${_selected!.latitude.toStringAsFixed(5)}, "
                    "${_selected!.longitude.toStringAsFixed(5)}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapIconButton extends StatelessWidget {
  const _MapIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
      ),
    );
  }
}

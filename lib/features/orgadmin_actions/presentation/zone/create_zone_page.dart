import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/zone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class CreateZonePage extends ConsumerStatefulWidget {
  const CreateZonePage({super.key, required this.onSuccess});
  final Function(Zone zone) onSuccess;

  @override
  ConsumerState<CreateZonePage> createState() => _CreateZonePageState();
}

class _CreateZonePageState extends ConsumerState<CreateZonePage> {
  final _zoneNameController = TextEditingController();
  final apiKey = dotenv.env['MAPTILER_API_KEY'];
  List<LatLng> _points = [];
  bool _isClosed = false;

  // Check if user tapped near first point to close polygon
  bool _isNearFirstPoint(LatLng tap) {
    if (_points.isEmpty) return false;
    const distance = Distance();
    final d = distance(_points.first, tap);
    return d < 50; // meters
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    if (_isClosed) return;

    setState(() {
      if (_points.length >= 3 && _isNearFirstPoint(latLng)) {
        _isClosed = true;
      } else {
        _points.add(latLng);
      }
    });
  }

  void _resetZone() {
    setState(() {
      _points.clear();
      _isClosed = false;
      _zoneNameController.clear();
    });
  }

  void _saveZone() async {
    if (_points.length < 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Add at least 3 points")));
      return;
    }

    final name = _zoneNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter a zone name")));
      return;
    }

    final wkt = _pointsToWKT(_points);

    debugPrint('ZONE SAVED: $name');
    debugPrint(wkt);

    final zone = Zone(id: "", name: _zoneNameController.text, wktPolygon: wkt);
    final result = await ref.read(orgAdminRepoProvider).createZone(zone);

    if (result is Zone) {
      widget.onSuccess.call(result);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Zone saved successfully!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $result")));
    }
  }

  String _pointsToWKT(List<LatLng> points) {
    final closedPoints = points.first == points.last
        ? points
        : [...points, points.first];
    final coords = closedPoints
        .map((p) => "${p.longitude} ${p.latitude}")
        .join(', ');
    return "POLYGON (($coords))";
  }

  @override
  Widget build(BuildContext context) {
    final center = _points.isNotEmpty ? _points[0] : LatLng(30.05, 31.237);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Zone"),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _resetZone)],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 12,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey',
                userAgentPackageName: 'com.example.delivera_flutter',
              ),
              if (_points.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _isClosed ? [..._points, _points.first] : _points,
                      strokeWidth: 3,
                      color: Colors.blue,
                    ),
                  ],
                ),
              if (_isClosed)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _points,
                      color: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: _points
                    .map(
                      (p) => Marker(
                        point: p,
                        width: 30,
                        height: 30,
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _zoneNameController,
                      decoration: InputDecoration(
                        labelText: "Zone Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _saveZone,
                      icon: Icon(Icons.save),
                      label: Text("Save Zone"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

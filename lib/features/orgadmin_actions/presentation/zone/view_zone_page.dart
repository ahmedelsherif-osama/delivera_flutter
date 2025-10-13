import 'package:delivera_flutter/features/utils/parse_wkt_polygon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../logic/zone_model.dart';

class ViewZonePage extends StatefulWidget {
  const ViewZonePage({super.key, required this.zone});
  final Zone zone;

  @override
  State<ViewZonePage> createState() => _ViewZonePageState();
}

class _ViewZonePageState extends State<ViewZonePage> {
  late List<LatLng> _points;
  final apiKey = dotenv.env['MAPTILER_API_KEY'];

  @override
  void initState() {
    super.initState();
    _points = parseWktPolygon(widget.zone.wktPolygon);
  }

  @override
  Widget build(BuildContext context) {
    final center = _points.isNotEmpty
        ? _points[0]
        : LatLng(25.2048, 55.2708); // default Dubai center

    return Scaffold(
      appBar: AppBar(title: Text(widget.zone.name)),
      body: FlutterMap(
        options: MapOptions(initialCenter: center, initialZoom: 12),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}.png?key=$apiKey',
            // userAgentPackageName: 'com.example.delivera_flutter',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: _points,
                color: Colors.blue.withOpacity(0.2),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
                // isFilled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:latlong2/latlong.dart';

List<LatLng> parseWktPolygon(String wktPolygon) {
  final coordinatesPart = wktPolygon
      .replaceAll(RegExp(r'POLYGON\s*\(\('), '')
      .replaceAll('))', '');
  final pairs = coordinatesPart.split(',');

  return pairs.map((pair) {
    final parts = pair.trim().split(' ');
    final lon = double.tryParse(parts[0]) ?? 0.0;
    final lat = double.tryParse(parts[1]) ?? 0.0;
    return LatLng(lat, lon);
  }).toList();
}

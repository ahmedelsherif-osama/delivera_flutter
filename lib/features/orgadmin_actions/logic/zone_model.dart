import 'package:equatable/equatable.dart';

class Zone extends Equatable {
  final String id;
  final String name;
  final String wktPolygon;

  const Zone({required this.id, required this.name, required this.wktPolygon});

  /// Empty instance
  factory Zone.empty() => const Zone(id: '', name: '', wktPolygon: '');

  /// Create from JSON
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      wktPolygon: json['wktPolygon'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'wktPolygon': wktPolygon,
  };

  /// Copy with new values
  Zone copyWith({String? id, String? name, String? wktPolygon}) {
    return Zone(
      id: id ?? this.id,
      name: name ?? this.name,
      wktPolygon: wktPolygon ?? this.wktPolygon,
    );
  }

  @override
  List<Object?> get props => [id, name, wktPolygon];
}

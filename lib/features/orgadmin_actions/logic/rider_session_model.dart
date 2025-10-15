import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:equatable/equatable.dart';

class RiderSession extends Equatable {
  final String id;
  final DateTime? startedAt;
  final double latitude;
  final double longitude;
  final String? zoneId;
  final String? zone;
  final String? riderId;
  final String? riderName;
  final String status;
  final DateTime? lastUpdated;
  final String? organizationId;
  final List<dynamic> activeOrders;
  final Location? currentOrderPickUp;
  final Location? currentOrderDropOff;
  final String? currentOrderId;

  const RiderSession({
    required this.id,
    this.startedAt,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.zoneId,
    this.zone,
    this.riderId,
    this.riderName,
    this.status = '',
    this.lastUpdated,
    this.organizationId,
    this.activeOrders = const [],
    this.currentOrderPickUp,
    this.currentOrderDropOff,
    this.currentOrderId,
  });

  /// 🧩 Empty constructor
  factory RiderSession.empty() => const RiderSession(
    id: '',
    startedAt: null,
    latitude: 0.0,
    longitude: 0.0,
    zoneId: null,
    zone: null,
    riderId: null,
    riderName: '',
    status: '',
    lastUpdated: null,
    organizationId: null,
    activeOrders: const [],
    currentOrderPickUp: null,
    currentOrderDropOff: null,
    currentOrderId: null,
  );

  /// 🧱 Create from JSON
  factory RiderSession.fromJson(Map<String, dynamic> json) => RiderSession(
    id: json['id'] ?? '',
    startedAt: json['startedAt'] != null
        ? DateTime.tryParse(json['startedAt'])
        : null,
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    zoneId: json['zoneId'],
    zone: json['zone'],
    riderId: json['riderId'],
    riderName: json['riderName'] ?? '',
    status: json['status'] ?? '',
    lastUpdated: json['lastUpdated'] != null
        ? DateTime.tryParse(json['lastUpdated'])
        : null,
    organizationId: json['organizationId'],
    activeOrders: json['activeOrders'] != null
        ? List<dynamic>.from(json['activeOrders'])
        : const [],
    currentOrderPickUp: json['currentOrderPickUp'] != null
        ? Location.fromJson(json['currentOrderPickUp'])
        : null,
    currentOrderDropOff: json['currentOrderDropOff'] != null
        ? Location.fromJson(json['currentOrderDropOff'])
        : null,
    currentOrderId: json['currentOrderId'] ?? null,
  );

  /// 🔁 Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'startedAt': startedAt?.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'zoneId': zoneId,
    'zone': zone,
    'riderId': riderId,
    'riderName': riderName,
    'status': status,
    'lastUpdated': lastUpdated?.toIso8601String(),
    'organizationId': organizationId,
    'activeOrders': activeOrders,
    'currentOrderPickUp': currentOrderPickUp?.toJson(),
    'currentOrderDropOff': currentOrderDropOff?.toJson(),
    'currentOrderId': currentOrderId,
  };

  /// 🧩 CopyWith method
  RiderSession copyWith({
    String? id,
    DateTime? startedAt,
    double? latitude,
    double? longitude,
    String? zoneId,
    String? zone,
    String? riderId,
    String? riderName,
    String? status,
    DateTime? lastUpdated,
    String? organizationId,
    List<dynamic>? activeOrders,
    Location? currentOrderPickUp,
    Location? currentOrderDropOff,
    String? currentOrderId,
  }) {
    return RiderSession(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zoneId: zoneId ?? this.zoneId,
      zone: zone ?? this.zone,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      organizationId: organizationId ?? this.organizationId,
      activeOrders: activeOrders ?? this.activeOrders,
      currentOrderPickUp: currentOrderPickUp ?? this.currentOrderPickUp,
      currentOrderDropOff: currentOrderDropOff ?? this.currentOrderDropOff,
      currentOrderId: currentOrderId ?? this.currentOrderId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    startedAt,
    latitude,
    longitude,
    zoneId,
    zone,
    riderId,
    riderName,
    status,
    lastUpdated,
    organizationId,
    activeOrders,
    currentOrderPickUp,
    currentOrderDropOff,
    currentOrderId,
  ];
}

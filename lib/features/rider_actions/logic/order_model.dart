import 'dart:convert';

class Order {
  final String id;
  final String organizationId;
  final String? riderId;
  final OrderStatus status;
  final Location pickUpLocation;
  final Location dropOffLocation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String orderDetails;
  final String? riderSessionId;
  final String createdById;

  Order({
    required this.id,
    required this.organizationId,
    this.riderId,
    required this.status,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.createdAt,
    required this.updatedAt,
    required this.orderDetails,
    this.riderSessionId,
    required this.createdById,
  });

  /// Empty instance for defaults
  factory Order.empty() => Order(
    id: '',
    organizationId: '',
    status: OrderStatus.created,
    pickUpLocation: Location.empty(),
    dropOffLocation: Location.empty(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    orderDetails: '',
    createdById: '',
  );

  /// Deserialize
  factory Order.fromJson(Map<String, dynamic> json) {
    print("so whats the json $json");
    return Order(
      id: json['id'] ?? '',
      organizationId: json['organizationId'] ?? '',
      riderId: json['riderId'],
      status: OrderStatusExtension.fromString(json['status']),
      pickUpLocation: Location.fromJson(json['pickUpLocation']),
      dropOffLocation: Location.fromJson(json['dropOffLocation']),

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      orderDetails: json['orderDetails'] ?? '',
      riderSessionId: json['riderSessionId'] ?? "",

      createdById: json['createdById'] ?? '',
    );
  }

  /// Serialize
  Map<String, dynamic> toJson() => {
    'organizationId': organizationId,
    'pickUpLocation': pickUpLocation.toJson(),
    'dropOffLocation': dropOffLocation.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'orderDetails': orderDetails,
  };

  /// CopyWith
  Order copyWith({
    String? id,
    String? organizationId,
    String? riderId,
    OrderStatus? status,
    Location? pickUpLocation,
    Location? dropOffLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderDetails,
    String? riderSessionId,
    String? createdById,
  }) {
    return Order(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      riderId: riderId ?? this.riderId,
      status: status ?? this.status,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderDetails: orderDetails ?? this.orderDetails,
      riderSessionId: riderSessionId ?? this.riderSessionId,
      createdById: createdById ?? this.createdById,
    );
  }
}

class Location {
  final String address;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory Location.empty() => Location(
    address: '',
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
  );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: json['address'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
  };

  Location copyWith({
    String? address,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
  }) {
    return Location(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum OrderStatus { created, assigned, delivered, canceled, pickedUp }

extension OrderStatusExtension on OrderStatus {
  static OrderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'created':
        return OrderStatus.created;
      case 'assigned':
        return OrderStatus.assigned;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
        return OrderStatus.canceled;
      case 'pickedup':
        return OrderStatus.pickedUp;
      default:
        return OrderStatus.created;
    }
  }
}

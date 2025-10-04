import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String id;
  final String shortCode;
  final String name;
  final String registrationNumber;
  final bool isApproved;
  final String ownerId;
  final dynamic owner; // could be another model later
  final List<dynamic> users; // replace with List<User> if you have a User model

  const Organization({
    required this.id,
    required this.shortCode,
    required this.name,
    required this.registrationNumber,
    required this.isApproved,
    required this.ownerId,
    this.owner,
    required this.users,
  });

  /// An empty placeholder Organization
  static const empty = Organization(
    id: '',
    shortCode: '',
    name: '',
    registrationNumber: '',
    isApproved: false,
    ownerId: '',
    owner: null,
    users: const [],
  );

  /// Create Organization from JSON map
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? '',
      shortCode: json['shortCode'] ?? '',
      name: json['name'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      isApproved: json['isApproved'] ?? false,
      ownerId: json['ownerId'] ?? '',
      owner: json['owner'],
      users: (json['users'] as List<dynamic>?) ?? [],
    );
  }

  /// Convert Organization to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shortCode': shortCode,
      'name': name,
      'registrationNumber': registrationNumber,
      'isApproved': isApproved,
      'ownerId': ownerId,
      'owner': owner,
      'users': users,
    };
  }

  /// Return a copy with modified fields
  Organization copyWith({
    String? id,
    String? shortCode,
    String? name,
    String? registrationNumber,
    bool? isApproved,
    String? ownerId,
    dynamic owner,
    List<dynamic>? users,
  }) {
    return Organization(
      id: id ?? this.id,
      shortCode: shortCode ?? this.shortCode,
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      isApproved: isApproved ?? this.isApproved,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [
    id,
    shortCode,
    name,
    registrationNumber,
    isApproved,
    ownerId,
    owner,
    users,
  ];
}

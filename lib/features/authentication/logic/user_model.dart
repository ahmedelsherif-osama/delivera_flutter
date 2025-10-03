import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? nationalId;
  final bool? isOrgOwnerApproved;
  final bool? isSuperAdminApproved;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final String globalRole;
  final String organizationRole;
  final String? createdById;
  final String? approvedById;
  final String? organizationId;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.globalRole,
    required this.organizationRole,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.nationalId,
    this.isOrgOwnerApproved,
    this.isSuperAdminApproved,
    this.isActive,
    this.createdAt,
    this.approvedAt,
    this.createdById,
    this.approvedById,
    this.organizationId,
  });

  /// Empty user (useful for initial state)
  factory User.empty() => const User(
    id: '',
    email: '',
    username: '',
    globalRole: '',
    organizationRole: '',
  );

  /// From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      nationalId: json['nationalId'] as String?,
      isOrgOwnerApproved: json['isOrgOwnerApproved'] as bool?,
      isSuperAdminApproved: json['isSuperAdminApproved'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      approvedAt: json['approvedAt'] != null
          ? DateTime.tryParse(json['approvedAt'])
          : null,
      globalRole: json['globalRole'] as String? ?? '',
      organizationRole: json['organizationRole'] as String? ?? '',
      createdById: json['createdById'] as String?,
      approvedById: json['approvedById'] as String?,
      organizationId: json['organizationId'] as String?,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'nationalId': nationalId,
      'isOrgOwnerApproved': isOrgOwnerApproved,
      'isSuperAdminApproved': isSuperAdminApproved,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'globalRole': globalRole,
      'organizationRole': organizationRole,
      'createdById': createdById,
      'approvedById': approvedById,
      'organizationId': organizationId,
    };
  }

  /// Copy with modification
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? nationalId,
    bool? isOrgOwnerApproved,
    bool? isSuperAdminApproved,
    bool? isActive,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? globalRole,
    String? organizationRole,
    String? createdById,
    String? approvedById,
    String? organizationId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationalId: nationalId ?? this.nationalId,
      isOrgOwnerApproved: isOrgOwnerApproved ?? this.isOrgOwnerApproved,
      isSuperAdminApproved: isSuperAdminApproved ?? this.isSuperAdminApproved,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      globalRole: globalRole ?? this.globalRole,
      organizationRole: organizationRole ?? this.organizationRole,
      createdById: createdById ?? this.createdById,
      approvedById: approvedById ?? this.approvedById,
      organizationId: organizationId ?? this.organizationId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    phoneNumber,
    firstName,
    lastName,
    dateOfBirth,
    nationalId,
    isOrgOwnerApproved,
    isSuperAdminApproved,
    isActive,
    createdAt,
    approvedAt,
    globalRole,
    organizationRole,
    createdById,
    approvedById,
    organizationId,
  ];
}

enum OrganizationRole { owner, admin, rider, support }

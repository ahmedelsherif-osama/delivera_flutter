import 'package:delivera_flutter/features/orgadmin_actions/logic/rider_session_model.dart';
import 'package:equatable/equatable.dart';

class RiderSummaryResponse extends Equatable {
  final List<RiderSession> activeRiderSessions;
  final List<RiderSession> onBreakRiderSessions;
  final List<RiderUser> offlineRiders;

  const RiderSummaryResponse({
    required this.activeRiderSessions,
    required this.onBreakRiderSessions,
    required this.offlineRiders,
  });

  factory RiderSummaryResponse.fromJson(Map<String, dynamic> json) {
    return RiderSummaryResponse(
      activeRiderSessions:
          (json['activeRiderSessions'] as List<dynamic>?)
              ?.map((e) => RiderSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      onBreakRiderSessions:
          (json['onBreakRiderSessions'] as List<dynamic>?)
              ?.map((e) => RiderSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offlineRiders:
          (json['offlineRiders'] as List<dynamic>?)
              ?.map((e) => RiderUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  RiderSummaryResponse copyWith({
    List<RiderSession>? activeRiderSessions,
    List<RiderSession>? onBreakRiderSessions,
    List<RiderUser>? offlineRiders,
  }) {
    return RiderSummaryResponse(
      activeRiderSessions: activeRiderSessions ?? this.activeRiderSessions,
      onBreakRiderSessions: onBreakRiderSessions ?? this.onBreakRiderSessions,
      offlineRiders: offlineRiders ?? this.offlineRiders,
    );
  }

  @override
  List<Object?> get props => [
    activeRiderSessions,
    onBreakRiderSessions,
    offlineRiders,
  ];
}

class RiderUser extends Equatable {
  final String id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? nationalId;
  final bool isActive;
  final String organizationId;

  const RiderUser({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.nationalId,
    required this.isActive,
    required this.organizationId,
  });

  factory RiderUser.fromJson(Map<String, dynamic> json) {
    return RiderUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'],
      nationalId: json['nationalId'],
      isActive: json['isActive'] ?? false,
      organizationId: json['organizationId'] ?? '',
    );
  }

  RiderUser copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? nationalId,
    bool? isActive,
    String? organizationId,
  }) {
    return RiderUser(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalId: nationalId ?? this.nationalId,
      isActive: isActive ?? this.isActive,
      organizationId: organizationId ?? this.organizationId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    firstName,
    lastName,
    isActive,
    organizationId,
  ];
}

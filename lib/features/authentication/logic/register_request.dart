import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String username;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String globalRole = "OrgUser";
  final String nationalId;
  final DateTime dateOfBirth;
  final OrganizationRole? organizationRole;
  final String? organizationShortCode;
  final String? organizationRegistrationNumber;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.nationalId,
    required this.dateOfBirth,
    this.organizationRole,
    this.organizationShortCode,
    this.organizationRegistrationNumber,
  });

  /// Empty constructor
  factory RegisterRequest.empty() => RegisterRequest(
    email: '',
    username: '',
    phoneNumber: '',
    firstName: '',
    lastName: '',
    password: '',
    nationalId: '',
    dateOfBirth: DateTime.now(),
    organizationRole: OrganizationRole.rider,
    organizationShortCode: '',
    organizationRegistrationNumber: '',
  );

  /// From JSON
  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      password: json['password'] ?? '',
      nationalId: json['nationalId'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? DateTime.now(),
      organizationRole: json['organizationRole'] ?? '',
      organizationShortCode: json['organizationShortCode'] ?? '',
      organizationRegistrationNumber: json['registrationNumber'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'nationalId': nationalId,
      'dateOfBirth': "2005-05-12",
      'organizationRole': organizationRole!.name,
      'organizationShortCode': organizationShortCode ?? "",
      "registrationNumber": organizationRegistrationNumber ?? "",
    };
  }

  /// CopyWith
  RegisterRequest copyWith({
    String? email,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? password,
    String? nationalId,
    DateTime? dateOfBirth,
    OrganizationRole? organizationRole,
    String? organizationShortCode,
    String? organizationRegistrationNumber,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      organizationRole: organizationRole ?? this.organizationRole,
      organizationShortCode:
          organizationShortCode ?? this.organizationShortCode,
      organizationRegistrationNumber:
          organizationRegistrationNumber ?? organizationRegistrationNumber,
    );
  }

  @override
  List<Object?> get props => [
    email,
    username,
    phoneNumber,
    firstName,
    lastName,
    password,
    globalRole,
    nationalId,
    dateOfBirth,
    organizationRole,
    organizationShortCode,
    organizationRegistrationNumber,
  ];
}

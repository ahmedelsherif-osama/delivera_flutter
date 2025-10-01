import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String username;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String globalRole;
  final String nationalId;
  final String dateOfBirth;
  final String? organizationRole;
  final String? organizationShortCode;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.globalRole,
    required this.nationalId,
    required this.dateOfBirth,
    this.organizationRole,
    this.organizationShortCode,
  });

  /// Empty constructor
  factory RegisterRequest.empty() => const RegisterRequest(
    email: '',
    username: '',
    phoneNumber: '',
    firstName: '',
    lastName: '',
    password: '',
    globalRole: '',
    nationalId: '',
    dateOfBirth: '',
    organizationRole: '',
    organizationShortCode: '',
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
      globalRole: json['globalRole'] ?? '',
      nationalId: json['nationalId'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      organizationRole: json['organizationRole'] ?? '',
      organizationShortCode: json['OrganizationShortCode'] ?? '',
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
      'globalRole': globalRole,
      'nationalId': nationalId,
      'dateOfBirth': dateOfBirth,
      'organizationRole': organizationRole,
      'OrganizationShortCode': organizationShortCode,
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
    String? globalRole,
    String? nationalId,
    String? dateOfBirth,
    String? organizationRole,
    String? organizationShortCode,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      globalRole: globalRole ?? this.globalRole,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      organizationRole: organizationRole ?? this.organizationRole,
      organizationShortCode:
          organizationShortCode ?? this.organizationShortCode,
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
  ];
}

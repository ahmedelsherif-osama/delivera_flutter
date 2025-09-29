import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String globalRole;
  final String organizationRole;

  const User({
    required this.id,
    required this.username,
    required this.globalRole,
    required this.organizationRole,
  });

  /// Empty user (useful for initial state)
  factory User.empty() =>
      const User(id: '', username: '', globalRole: '', organizationRole: '');

  /// From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      globalRole: json['globalRole'] as String? ?? '',
      organizationRole: json['organizationRole'] as String? ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'globalRole': globalRole,
      'organizationRole': organizationRole,
    };
  }

  /// Copy with modification
  User copyWith({
    String? id,
    String? username,
    String? globalRole,
    String? organizationRole,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      globalRole: globalRole ?? this.globalRole,
      organizationRole: organizationRole ?? this.organizationRole,
    );
  }

  @override
  List<Object?> get props => [id, username, globalRole, organizationRole];
}

enum OrganizationRole { rider, support, admin, owner }

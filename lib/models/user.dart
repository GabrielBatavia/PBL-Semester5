// lib/models/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? status;       // raw dari backend: pending / diterima / dll
  final String? roleName;     // admin, ketua_rt, dst
  final String? roleDisplay;  // Ketua RT, Admin Sistem, dst

  User({
    required this.id,
    required this.name,
    required this.email,
    this.status,
    this.roleName,
    this.roleDisplay,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as Map<String, dynamic>?;
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String?,
      roleName: role != null ? role['name'] as String? : null,
      roleDisplay: role != null ? role['display_name'] as String? : null,
    );
  }
}

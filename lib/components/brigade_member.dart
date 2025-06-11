class BrigadeMember {
  final dynamic id;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String role;
  final String createdAt;
  final String updatedAt;
  final String? emailVerifiedAt;

  const BrigadeMember({required this.id, required this.name, required this.lastname, required this.password, required this.email, required this.role, required this.createdAt, required this.updatedAt, required this.emailVerifiedAt});
  
  factory BrigadeMember.fromJson(Map<String, dynamic> json) {
    return BrigadeMember(
      id: json['user']['id'] as int,
      name: json['user']['name'] as String? ?? '',
      lastname: json['user']['lastname'] as String? ?? '',
      email: json['user']['email'] as String? ?? '',
      password: json['user']['password'] as String? ?? '',
      role: json['user']['role'] as String? ?? '',
      createdAt: json['user']['created_at'] as String? ?? '',
      updatedAt: json['user']['updated_at'] as String? ?? '',
      emailVerifiedAt: json['user']['email_verified_at'] as String? ?? ''
    );
  }
}

class User {
  final dynamic id;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String? emailVerifiedAt;
  final String? phone;

  const User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.password,
    required this.email,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerifiedAt,
    required this.phone,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  void operator [](String other) {}
}

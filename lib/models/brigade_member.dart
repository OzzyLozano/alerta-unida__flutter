class BrigadeMember {
  final dynamic id;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String role;
  final List<String> training;
  final String createdAt;
  final String updatedAt;
  final String? emailVerifiedAt;
  final String? phone;

  const BrigadeMember({
    required this.id,
    required this.name,
    required this.lastname,
    required this.password,
    required this.email,
    required this.role,
    required this.training,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerifiedAt,
    required this.phone,
  });
  
  factory BrigadeMember.fromJson(Map<String, dynamic> json) {
    final trainingList = <String>[];
    if (json['traininginfo'] != null && json['traininginfo'] is List) {
      final training = json['traininginfo'][0]; // primer registro
      if (training['evacuacion'] == true) trainingList.add("Evacuación");
      if (training['prevencion_combate'] == true) trainingList.add("Prevención y Combate");
      if (training['busqueda_rescate'] == true) trainingList.add("Búsqueda y Rescate");
      if (training['primeros_auxilios'] == true) trainingList.add("Primeros Auxilios");
    }
    return BrigadeMember(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? '',
      training: trainingList,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

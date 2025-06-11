class Report {
  final int id;
  final String title;
  final String description;
  final String img;
  final String status;
  final String userId;
  final String brigadeMemberId;

  Report(this.userId, this.brigadeMemberId, {required this.id, required this.title, required this.description, required this.img, required this.status});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      json['userId'] as String? ?? 'Desconocido',
      json['brigadeMemberId'] as String? ?? 'Desconocido',
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? 'Sin Descripción',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      status: json['status'] as String? ?? 'Sin estado',
    );
  }
}

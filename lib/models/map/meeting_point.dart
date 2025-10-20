class MeetingPoint {
  final int id;
  final String description;
  final double latitude;
  final double longitude;
  final String img;

  MeetingPoint({required this.id, required this.description, required this.latitude, required this.longitude, required this.img});

  factory MeetingPoint.fromJson(Map<String, dynamic> json) {
    return MeetingPoint(
      id: json['id'] as int,
      description: json['description'] as String? ?? 'Sin Descripción',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}

class Gate {
  final int id;
  final String description;
  final double latitude;
  final double longitude;
  final String img;
  final List<Equipment> equipments;

  Gate({required this.id, required this.description, required this.latitude, required this.longitude, required this.img, required this.equipments});

  factory Gate.fromJson(Map<String, dynamic> json) {
    return Gate(
      id: json['id'] as int,
      description: json['description'] as String? ?? 'Sin Descripción',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      equipments: (json['equipments'] as List<dynamic>?)?.map((e) => Equipment.fromJson(e)).toList() ?? [],
    );
  }
}

class Equipment {
  final int id;
  final String description;
  final String img;

  Equipment({ required this.id, required this.description, required this.img });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as int,
      description: json['description'] as String? ?? 'Sin Descripción',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
    );
  }
}

class Building {
  final int id;
  final String name;
  final double latitude_1;
  final double longitude_1;
  final double latitude_2;
  final double longitude_2;
  final double latitude_3;
  final double longitude_3;
  final double latitude_4;
  final double longitude_4;
  final String img;
  final List<Floor> floors;

  Building({required this.latitude_1, required this.longitude_1, required this.latitude_2, required this.longitude_2, required this.latitude_3, required this.longitude_3, required this.latitude_4, required this.longitude_4, required this.id, required this.name, required this.img, required this.floors});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Sin Nombre',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      latitude_1: double.tryParse(json['latitude_1'].toString()) ?? 0.0,
      longitude_1: double.tryParse(json['longitude_1'].toString()) ?? 0.0,
      latitude_2: double.tryParse(json['latitude_2'].toString()) ?? 0.0,
      longitude_2: double.tryParse(json['longitude_2'].toString()) ?? 0.0,
      latitude_3: double.tryParse(json['latitude_3'].toString()) ?? 0.0,
      longitude_3: double.tryParse(json['longitude_3'].toString()) ?? 0.0,
      latitude_4: double.tryParse(json['latitude_4'].toString()) ?? 0.0,
      longitude_4: double.tryParse(json['longitude_4'].toString()) ?? 0.0,
      floors: (json['floors'] as List<dynamic>?)?.map((e) => Floor.fromJson(e)).toList() ?? [],
    );
  }
}

class Floor {
  final int id;
  final String level;
  final List<Equipment> equipments;

  Floor({required this.id, required this.level, required this.equipments});

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'] as int,
      level: json['level'] as String? ?? 'Sin Nombre',
      equipments: (json['equipments'] as List<dynamic>?)?.map((e) => Equipment.fromJson(e)).toList() ?? [],
    );
  }
}

class Equipment {
  final int id;
  final String description;
  final String img;
  final Pivot pivot;

  Equipment({ required this.id, required this.description, required this.img, required this.pivot });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as int,
      description: json['description'] as String? ?? 'Sin Descripción',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      pivot: Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );
  }
}

class Pivot {
  final int floorId;
  final double latitude;
  final double longitude;

  Pivot({required this.floorId, required this.latitude, required this.longitude});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      floorId: json['floor_id'] as int,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}

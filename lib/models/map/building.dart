class Building {
  final int id;
  final String name;
  final double initialLatitude;
  final double initialLongitude;
  final double finalLatitude;
  final double finalLongitude;
  final String img;
  final List<Floor> floors;

  Building({required this.id, required this.name, required this.initialLatitude, required this.initialLongitude, required this.finalLatitude, required this.finalLongitude, required this.img, required this.floors});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Sin Nombre',
      img: json['img_path'] as String? ?? 'No se encontró una imagen',
      initialLatitude: double.tryParse(json['initial_latitude'].toString()) ?? 0.0,
      initialLongitude: double.tryParse(json['initial_longitude'].toString()) ?? 0.0,
      finalLatitude: double.tryParse(json['final_latitude'].toString()) ?? 0.0,
      finalLongitude: double.tryParse(json['final_longitude'].toString()) ?? 0.0,
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

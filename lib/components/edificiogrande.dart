class EdificioGrande {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  EdificioGrande({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory EdificioGrande.fromJson(Map<String, dynamic> json) {
    return EdificioGrande(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

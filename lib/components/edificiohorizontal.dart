class EdificioHor {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  EdificioHor({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory EdificioHor.fromJson(Map<String, dynamic> json) {
    return EdificioHor(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

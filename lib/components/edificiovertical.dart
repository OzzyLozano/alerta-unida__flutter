class EdificioVer {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  EdificioVer({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory EdificioVer.fromJson(Map<String, dynamic> json) {
    return EdificioVer(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

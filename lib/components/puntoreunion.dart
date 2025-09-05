class PuntoReunion {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  PuntoReunion({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory PuntoReunion.fromJson(Map<String, dynamic> json) {
    return PuntoReunion(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

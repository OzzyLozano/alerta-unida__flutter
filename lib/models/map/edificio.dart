class Edificio {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  Edificio({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory Edificio.fromJson(Map<String, dynamic> json) {
    return Edificio(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

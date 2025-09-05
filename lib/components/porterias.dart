class Porterias {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  Porterias({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory Porterias.fromJson(Map<String, dynamic> json) {
    return Porterias(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

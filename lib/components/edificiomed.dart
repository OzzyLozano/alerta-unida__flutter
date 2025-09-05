class EdificioMed {
  final String nombre;
  final double lat;
  final double lng;
  final String informacion;

  EdificioMed({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.informacion,
  });

  factory EdificioMed.fromJson(Map<String, dynamic> json) {
    return EdificioMed(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      informacion: json['informacion'],
    );
  }
}

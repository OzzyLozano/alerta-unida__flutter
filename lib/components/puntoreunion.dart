class Extintor {
  final String imagen;
  final String descripcion;

  Extintor({
    required this.imagen,
    required this.descripcion,
  });

  factory Extintor.fromJson(Map<String, dynamic> json) {
    return Extintor(
      imagen: json['imagen'],
      descripcion: json['descripcion'],
    );
  }
}
class PuntoReunion {
  final String nombre;
  final double lat;
  final double lng;
  final String imagenPrincipal;
  final Map<String, List<Extintor>> plantas;


  PuntoReunion({
    required this.nombre,
    required this.lat,
    required this.lng,
    required this.imagenPrincipal,
    required this.plantas,


  });

  factory PuntoReunion.fromJson(Map<String, dynamic> json) {
    // Convertir cada planta en lista de Extintor
    final Map<String, dynamic> plantasJson = json['plantas'];
    final plantasMap = plantasJson.map((planta, lista) {
      final extintores = (lista as List)
          .map((e) => Extintor.fromJson(e))
          .toList();
      return MapEntry(planta, extintores);
    });
    return PuntoReunion(
      nombre: json['nombre'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      imagenPrincipal: json['imagenPrincipal'],
      plantas: plantasMap,

    );
  }
}

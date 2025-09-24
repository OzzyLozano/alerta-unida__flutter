import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:photo_view/photo_view.dart';

import 'package:app_test/components/edificiogrande.dart';
import 'package:app_test/components/porterias.dart';
import 'package:app_test/components/puntoreunion.dart';

class OSMMap extends StatefulWidget {
  const OSMMap({super.key});

  @override
  State<OSMMap> createState() => _OSMMapState();
}

class _OSMMapState extends State<OSMMap> {

  bool _isSatellite = false; // ← Nuevo: alternar entre normal y satélite

  // URLs para mapas
  final String _dayMapUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  final String _satelliteMapUrl = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";

  LatLng? userLocation;
  final LatLng _initialCoords = const LatLng(25.842444, -97.453585);
  final MapController _mapController = MapController();
  GeoJsonParser roadsGeoJson = GeoJsonParser();

  List<EdificioGrande> edificiosgrandes = [];
  List<Porterias> porterias = [];
  List<PuntoReunion> puntosdereunion = [];

  // Lista para buscador
  List<Map<String, dynamic>> ubicacionesDestacadas = [];

  @override
  void initState() {
    super.initState();
    loadRoadsGeoJson();
    _cargarTodo();
    startTrackingUserLocation();
  }

  Future<void> _cargarTodo() async {
    await Future.wait([
      loadEdificiosGrandes(),
      loadPuntosdeReunion(),
      loadPorterias(),
    ]);
    buildUbicacionesDestacadas();
  }

  void startTrackingUserLocation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      setState(() {
        userLocation = newPos;
      });
      _mapController.move(newPos, 18);
    });
  }

  Future<void> loadRoadsGeoJson() async {
    String roadsContent = await rootBundle.loadString('geojson/roads.geojson');
    roadsGeoJson.parseGeoJsonAsString(roadsContent);
    setState(() {});
  }

  Future<void> loadEdificiosGrandes() async {
    String data = await rootBundle.loadString("assets/coordenadasgrande.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      edificiosgrandes = jsonResult.map((e) => EdificioGrande.fromJson(e)).toList();
    });
  }

  Future<void> loadPuntosdeReunion() async {
    String data = await rootBundle.loadString("assets/coordenadaspuntoreunion.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      puntosdereunion = jsonResult.map((e) => PuntoReunion.fromJson(e)).toList();
    });
  }

  Future<void> loadPorterias() async {
    String data = await rootBundle.loadString("assets/coordenadasPorterias.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      porterias = jsonResult.map((e) => Porterias.fromJson(e)).toList();
    });
  }

  void _showFullPlantImage(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: PhotoView(
            imageProvider: AssetImage(imagePath),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3.0,
          ),
        ),
      ),
    );
  }

  void buildUbicacionesDestacadas() {
    ubicacionesDestacadas.clear();
    for (var e in edificiosgrandes) {
      ubicacionesDestacadas.add({"nombre": e.nombre, "lat": e.lat, "lng": e.lng});
    }
    for (var e in puntosdereunion) {
      ubicacionesDestacadas.add({"nombre": e.nombre, "lat": e.lat, "lng": e.lng});
    }
    for (var e in porterias) {
      ubicacionesDestacadas.add({"nombre": e.nombre, "lat": e.lat, "lng": e.lng});
    }
    setState(() {});
  }

  // ----------------- Marcadores -----------------
  List<Marker> _buildEdificioGrandeMarkers() => edificiosgrandes.map((e) => Marker(
    point: LatLng(e.lat, e.lng),
    width: 80,
    height: 60,
    child: GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _buildEdificioGrandeSheet(e),
      ),
      child: Container(color: Colors.transparent),
    ),
  )).toList();

  Widget _buildEdificioGrandeSheet(EdificioGrande e) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text(e.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            if (e.imagenPrincipal.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(e.imagenPrincipal, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            const SizedBox(height: 12),
            const Divider(),
            ...e.plantas.entries.map((entry) => ExpansionTile(
              title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: entry.value.map((ex) => ListTile(
                leading: GestureDetector(
                  onTap: () => _showFullPlantImage(ex.imagen),
                  child: Image.asset(ex.imagen, width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(ex.descripcion),
              )).toList(),
            )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
            )
          ],
        ),
      ),
    );
  }

  List<Marker> _buildPuntosReunionMarkers() => puntosdereunion.map((e) => Marker(
    point: LatLng(e.lat, e.lng),
    width: 50,
    height: 50,
    child: GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => _buildPuntoReunionSheet(e)),
      child: const Icon(Icons.health_and_safety, color: Colors.greenAccent),
    ),
  )).toList();

  Widget _buildPuntoReunionSheet(PuntoReunion e) => _simpleSheet(e.nombre, e.imagenPrincipal);

  List<Marker> _buildPorteriaMarkers() => porterias.map((e) => Marker(
    point: LatLng(e.lat, e.lng),
    width: 50,
    height: 50,
    child: GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => _buildPorteriasSheet(e)),
      child: const Icon(Icons.security, color: Colors.black),
    ),
  )).toList();

  Widget _buildPorteriasSheet(Porterias e) => _simpleSheet(e.nombre, e.imagenPrincipal);

  Widget _simpleSheet(String nombre, String imagen) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (imagen.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagen, fit: BoxFit.cover, height: 180, width: double.infinity),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow.shade200, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCoords,
                  initialZoom: 18,
                  maxZoom: 20,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.scrollWheelZoom,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: _isSatellite ? _satelliteMapUrl : _dayMapUrl,
                  ),
                  if (roadsGeoJson.polygons.isNotEmpty)
                    PolygonLayer(
                      polygons: roadsGeoJson.polygons
                          .map((p) => Polygon(
                        points: p.points,
                        color: Colors.grey.withOpacity(0.5),
                        borderColor: Colors.black,
                        borderStrokeWidth: 2,
                      ))
                          .toList(),
                    ),
                  if (roadsGeoJson.polylines.isNotEmpty)
                    PolylineLayer(
                      polylines: roadsGeoJson.polylines
                          .map((line) => Polyline(points: line.points, color: Colors.green.shade200, strokeWidth: 3))
                          .toList(),
                    ),
                  if (userLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLocation!,
                          width: 20,
                          height: 20,
                          child: const Icon(Icons.circle, size: 15, color: Colors.red),
                        ),
                      ],
                    ),
                  if (edificiosgrandes.isNotEmpty) MarkerLayer(markers: _buildEdificioGrandeMarkers()),
                  if (porterias.isNotEmpty) MarkerLayer(markers: _buildPorteriaMarkers()),
                  if (puntosdereunion.isNotEmpty) MarkerLayer(markers: _buildPuntosReunionMarkers()),
                ],
              ),
            ),
          ),
        ),
        // Botón alternar mapa normal/satélite
        Positioned(
          bottom: 40,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(_isSatellite ? Icons.map : Icons.satellite),
            onPressed: () {
              setState(() {
                _isSatellite = !_isSatellite;
              });
            },
          ),
        ),

        // Barra de búsqueda
        Positioned(
          top: 40,
          left: 24,
          right: 24,
          child: GestureDetector(
            onTap: () async {
              if (ubicacionesDestacadas.isEmpty) return;
              final lugar = await showSearch(
                context: context,
                delegate: UbicacionSearch(ubicacionesDestacadas),
              );
              if (lugar != null && lugar.isNotEmpty) {
                _mapController.move(LatLng(lugar['lat'], lugar['lng']), 18);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Buscar ubicación...", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Buscador reutilizable
class UbicacionSearch extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> lugares;
  UbicacionSearch(this.lugares);

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = "")];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, {}));

  @override
  Widget buildResults(BuildContext context) {
    final resultados = lugares
        .where((l) => l['nombre'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _listado(resultados);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugerencias = lugares
        .where((l) => l['nombre'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _listado(sugerencias);
  }

  Widget _listado(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final lugar = data[i];
        return ListTile(
          title: Text(lugar['nombre']),
          onTap: () => close(_, lugar),
        );
      },
    );
  }
}

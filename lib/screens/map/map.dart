import 'package:app_test/models/map/building.dart';
import 'package:app_test/models/map/gate.dart';
import 'package:app_test/models/map/meeting_point.dart';
import 'package:app_test/screens/map/components/buildings.dart';
import 'package:app_test/screens/map/components/gates.dart';
import 'package:app_test/screens/map/components/meeting_points.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OSMMap extends StatefulWidget {
  const OSMMap({super.key});

  @override
  State<OSMMap> createState() => _OSMMapState();
}

class _OSMMapState extends State<OSMMap> {
  late List<MeetingPoint> meetingPoints = [];
  late List<Gate> gates = [];
  late List<Building> buildings = [];

  bool _isSatellite = false; // ← Nuevo: alternar entre normal y satélite

  // URLs para mapas
  final String _dayMapUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  final String _satelliteMapUrl = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";

  LatLng? userLocation;
  final LatLng _initialCoords = const LatLng(25.842444, -97.453585);
  final MapController _mapController = MapController();
  GeoJsonParser roadsGeoJson = GeoJsonParser();

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
    try {
      final loadedBuildings = await loadBuildings();
      final loadedGates = await loadGates();
      final loadedMeetingPoints = await loadMeetingPoints();

      setState(() {
        buildings = loadedBuildings;
        gates = loadedGates;
        meetingPoints = loadedMeetingPoints;
      });

      buildUbicacionesDestacadas();
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando datos: $e');
      }
    }
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
      // _mapController.move(newPos, 18);
    });
  }

  Future<void> loadRoadsGeoJson() async {
    String roadsContent = await rootBundle.loadString('geojson/roads.geojson');
    roadsGeoJson.parseGeoJsonAsString(roadsContent);
    setState(() {});
  }

  void buildUbicacionesDestacadas() {
    ubicacionesDestacadas.clear();
    for (var building in buildings) {
      ubicacionesDestacadas.add({"nombre": building.name, "lat": building.latitude_1, "lng": building.longitude_1});
    }
    for (var gate in gates) {
      ubicacionesDestacadas.add({"nombre": gate.description, "lat": gate.latitude, "lng": gate.longitude});
    }
    for (var meetingPoint in meetingPoints) {
      ubicacionesDestacadas.add({"nombre": meetingPoint.description, "lat": meetingPoint.latitude, "lng": meetingPoint.longitude});
    }
    setState(() {});
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
                  initialZoom: 17,
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
                      polygons: buildings.map((building) {
                        return Polygon(
                          points: [
                            LatLng(building.latitude_1, building.longitude_1),
                            LatLng(building.latitude_2, building.longitude_2),
                            LatLng(building.latitude_3, building.longitude_3),
                            LatLng(building.latitude_4, building.longitude_4),
                          ],
                          color: Colors.lightBlue.withOpacity(0.5),
                          borderStrokeWidth: 2,
                          borderColor: Colors.black,
                        );
                      }).toList(),
                    ),
                    PolygonLayer(
                      polygons: roadsGeoJson.polygons
                          .map((p) => Polygon(
                        points: p.points,
                        color: Colors.grey.withOpacity(0.5),
                        borderColor: Colors.black.withOpacity(0.5),
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
                          child: const Icon(Icons.circle, size: 15, color: Colors.blue),
                        ),
                      ],
                    ),
                  if (buildings.isNotEmpty) MarkerLayer(markers: buildBuildingsMarkers(context, buildings)),
                  if (gates.isNotEmpty) MarkerLayer(markers: buildGateMarkers(context, gates)),
                  if (meetingPoints.isNotEmpty) MarkerLayer(markers: BuildMeetingPointsMarkers(context, meetingPoints)),
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
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: const Row(
                children: [
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

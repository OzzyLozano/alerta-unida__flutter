import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:app_test/components/EdificioMed.dart';
import 'package:app_test/components/edificiogrande.dart';
import 'package:app_test/components/porterias.dart';
import 'package:app_test/components/puntoreunion.dart';
import 'package:app_test/components/edificiohorizontal.dart';
import 'package:app_test/components/edificiovertical.dart';

class OSMMap extends StatefulWidget {
  const OSMMap({super.key});

  @override
  State<OSMMap> createState() => _OSMMapState();
}

class _OSMMapState extends State<OSMMap> {
  LatLng? userLocation;
  final String _mapUrlTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  final LatLng _initialCoords = const LatLng(25.842444, -97.453585);

  GeoJsonParser roadsGeoJson = GeoJsonParser(); // Solo roads.geojson

  List<EdificioGrande> edificiosgrandes = [];
  List<Porterias> porterias = [];
  List<EdificioMed> edificiosmedianos = [];
  List<EdificioHor> edificioshorizontales = [];
  List<EdificioVer> edificiosverticales = [];
  List<PuntoReunion> puntosdereunion = [];

  @override
  void initState() {
    super.initState();
    loadRoadsGeoJson();
    loadEdificiosGrandes();
    loadEdificiosMedianos();
    loadEdificiosHorizontales();
    loadEdificiosVerticales();
    loadPuntosdeReunion();
    loadPorterias();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
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

  Future<void> loadEdificiosMedianos() async {
    String data = await rootBundle.loadString("assets/coordenadasmediano.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      edificiosmedianos = jsonResult.map((e) => EdificioMed.fromJson(e)).toList();
    });
  }

  Future<void> loadEdificiosHorizontales() async {
    String data = await rootBundle.loadString("assets/coordenadashorizontal.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      edificioshorizontales = jsonResult.map((e) => EdificioHor.fromJson(e)).toList();
    });
  }

  Future<void> loadEdificiosVerticales() async {
    String data = await rootBundle.loadString("assets/coordenadasvertical.json");
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      edificiosverticales = jsonResult.map((e) => EdificioVer.fromJson(e)).toList();
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

  // Marcadores existentes...
  List<Marker> _buildEdificioGrandeMarkers() {
    return edificiosgrandes.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 80,
        height: 60,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
          child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
        ),
      );
    }).toList();
  }

  List<Marker> _buildEdificioMedianoMarkers() {
    return edificiosmedianos.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 80,
        height: 60,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
          child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
        ),
      );
    }).toList();
  }

  List<Marker> _buildEdificioHorizontalMarkers() {
    return edificioshorizontales.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 100,
        height: 40,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
          child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
        ),
      );
    }).toList();
  }

  List<Marker> _buildEdificioVerticalMarkers() {
    return edificiosverticales.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 40,
        height: 100,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
          child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
        ),
      );
    }).toList();
  }

  List<Marker> _buildPuntosReunionMarkers() {
    return puntosdereunion.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 50,
        height: 50,
        child: IconButton(
          icon: const Icon(Icons.health_and_safety, color: Colors.greenAccent),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
        ),
      );
    }).toList();
  }

  List<Marker> _buildPorteriaMarkers() {
    return porterias.map((e) {
      return Marker(
        point: LatLng(e.lat, e.lng),
        width: 50,
        height: 50,
        child: IconButton(
          icon: const Icon(Icons.security, color: Colors.grey),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(e.nombre),
                content: Text(e.informacion),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
                ],
              ),
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _initialCoords,
        initialZoom: 18,
        maxZoom: 20,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(25.84576, -97.45573),
            const LatLng(25.83873, -97.45160),
          ),
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.scrollWheelZoom,
        ),
      ),
      children: [
        TileLayer(urlTemplate: _mapUrlTemplate),

        // Polígonos y líneas desde roads.geojson
        if (roadsGeoJson.polygons.isNotEmpty)
          PolygonLayer(
            polygons: roadsGeoJson.polygons.map((p) {
              return Polygon(
                points: p.points,
                color: Colors.grey.withOpacity(0.5),
                borderColor: Colors.black,
                borderStrokeWidth: 2,
              );
            }).toList(),
          ),

        if (roadsGeoJson.polylines.isNotEmpty)
          PolylineLayer(
            polylines: roadsGeoJson.polylines.map((line) {
              return Polyline(
                points: line.points,
                color: Colors.green,
                strokeWidth: 3,
              );
            }).toList(),
          ),

        // Marcador de ubicación del usuario
        if (userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 40,
                height: 40,
                child: const Icon(Icons.my_location, size: 20, color: Colors.blue),
              ),
            ],
          ),

        // Marcadores de edificios y puntos
        if (edificiosgrandes.isNotEmpty) MarkerLayer(markers: _buildEdificioGrandeMarkers()),
        if (porterias.isNotEmpty) MarkerLayer(markers: _buildPorteriaMarkers()),
        if (puntosdereunion.isNotEmpty) MarkerLayer(markers: _buildPuntosReunionMarkers()),
        if (edificiosmedianos.isNotEmpty) MarkerLayer(markers: _buildEdificioMedianoMarkers()),
        if (edificioshorizontales.isNotEmpty) MarkerLayer(markers: _buildEdificioHorizontalMarkers()),
        if (edificiosverticales.isNotEmpty) MarkerLayer(markers: _buildEdificioVerticalMarkers()),
      ],
    );
  }
}

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

  final MapController _mapController = MapController();

  GeoJsonParser roadsGeoJson = GeoJsonParser();

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
  startTrackingUserLocation();
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

  // ----------------- Marcadores -----------------
  List<Marker> _buildEdificioGrandeMarkers() {
  return edificiosgrandes.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 80,
  height: 60,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _buildEdificioGrandeSheet(e),
  );
  },
  child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
  ),
  );
  }).toList();
  }

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
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta, style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer(
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(ex.imagen, fit: BoxFit.contain),
  ),
  ),
  ),
  );
  },
  child: Image.asset(ex.imagen, width: 50, height: 50, fit: BoxFit.cover),
  ),
  title: Text(ex.descripcion),
  );
  }).toList(),
  );
  }).toList(),
  const SizedBox(height: 8),
  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))
  ]),
  ],
  ),
  ),
  );
  }

  List<Marker> _buildEdificioMedianoMarkers() {
  return edificiosmedianos.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 80,
  height: 60,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _buildEdificioMedSheet(e),
  );
  },
  child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
  ),
  );
  }).toList();
  }

  Widget _buildEdificioMedSheet(EdificioMed e) {
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
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta, style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer(
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(ex.imagen, fit: BoxFit.contain),
  ),
  ),
  ),
  );
  },
  child: Image.asset(ex.imagen, width: 50, height: 50, fit: BoxFit.cover),
  ),
  title: Text(ex.descripcion),
  );
  }).toList(),
  );
  }).toList(),
  const SizedBox(height: 8),
  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))
  ]),
  ],
  ),
  ),
  );
  }

  List<Marker> _buildEdificioHorizontalMarkers() {
  return edificioshorizontales.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 100,
  height: 40,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _buildEdificioHorSheet(e),
  );
  },
  child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
  ),
  );
  }).toList();
  }

  Widget _buildEdificioHorSheet(EdificioHor e) {
  return Padding(
  padding: const EdgeInsets.all(16),
  child: SingleChildScrollView(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
  Center(
  child: Text(
  e.nombre,
  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  ),
  if (e.imagenPrincipal.isNotEmpty)
  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  e.imagenPrincipal,
  fit: BoxFit.cover,
  height: 180,
  width: double.infinity,
  ),
  ),
  const Divider(),
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta, style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer(
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(ex.imagen, fit: BoxFit.contain),
  ),
  ),
  ),
  );
  },
  child: Image.asset(ex.imagen, width: 50, height: 50, fit: BoxFit.cover),
  ),
  title: Text(ex.descripcion),
  );
  }).toList(),
  );
  }).toList(),
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))],
  ),
  ],
  ),
  ),
  );
  }



  List<Marker> _buildEdificioVerticalMarkers() {
  return edificiosverticales.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 40,
  height: 100,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  builder: (_) => _buildEdificioVerticalSheet(e),
  );
  },
  child: Icon(Icons.health_and_safety, color: Colors.greenAccent),
  ),

  );
  }).toList();
  }

  Widget _buildEdificioVerticalSheet(EdificioVer e) {
  return Padding(
  padding: const EdgeInsets.all(16),
  child: SingleChildScrollView(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
  Center(
  child: Text(
  e.nombre,
  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  ),
  const SizedBox(height: 12),
  if (e.imagenPrincipal.isNotEmpty)
  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  e.imagenPrincipal,
  fit: BoxFit.cover,
  height: 180,
  width: double.infinity,
  ),
  ),
  const SizedBox(height: 12),
  const Divider(),
  // 🔽 Nuevo: Listado por plantas
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta,
  style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer( // 👉 Permite hacer zoom y mover
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  ex.imagen,
  fit: BoxFit.contain,
  ),
  ),
  ),
  ),
  );
  },
  child: Image.asset(
  ex.imagen,
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  ),
  ),
  title: Text(ex.descripcion),
  );

  }).toList(),
  );
  }).toList(),
  const SizedBox(height: 8),
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: const Text("Cerrar"),
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }
  List<Marker> _buildPuntosReunionMarkers() {
  return puntosdereunion.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 50,
  height: 50,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  builder: (_) => _buildPuntoReunionSheet(e),
  );
  },
  child: Icon(Icons.health_and_safety, color: Colors.greenAccent),
  ),

  );
  }).toList();
  }

  Widget _buildPuntoReunionSheet(PuntoReunion e) {
  return Padding(
  padding: const EdgeInsets.all(16),
  child: SingleChildScrollView(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
  Center(
  child: Text(
  e.nombre,
  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  ),
  const SizedBox(height: 12),
  if (e.imagenPrincipal.isNotEmpty)
  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  e.imagenPrincipal,
  fit: BoxFit.cover,
  height: 180,
  width: double.infinity,
  ),
  ),
  const SizedBox(height: 12),
  const Divider(),
  // 🔽 Nuevo: Listado por plantas
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta,
  style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer( // 👉 Permite hacer zoom y mover
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  ex.imagen,
  fit: BoxFit.contain,
  ),
  ),
  ),
  ),
  );
  },
  child: Image.asset(
  ex.imagen,
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  ),
  ),
  title: Text(ex.descripcion),
  );

  }).toList(),
  );
  }).toList(),
  const SizedBox(height: 8),
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: const Text("Cerrar"),
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }

  List<Marker> _buildPorteriaMarkers() {
  return porterias.map((e) {
  return Marker(
  point: LatLng(e.lat, e.lng),
  width: 50,
  height: 50,
  child: GestureDetector(
  onTap: () {
  showModalBottomSheet(
  context: context,
  builder: (_) => _buildPorteriasSheet(e),
  );
  },
  child: Icon(Icons.health_and_safety, color: Colors.greenAccent),
  ),

  );
  }).toList();
  }

  <<<<<<< HEAD
  Widget _buildPorteriasSheet(Porterias e) {
  return Padding(
  padding: const EdgeInsets.all(16),
  child: SingleChildScrollView(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
  Center(
  child: Text(
  e.nombre,
  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  ),
  const SizedBox(height: 12),
  if (e.imagenPrincipal.isNotEmpty)
  ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  e.imagenPrincipal,
  fit: BoxFit.cover,
  height: 180,
  width: double.infinity,
  ),
  ),
  const SizedBox(height: 12),
  const Divider(),
  // 🔽 Nuevo: Listado por plantas
  ...e.plantas.entries.map((entry) {
  final planta = entry.key;
  final extintores = entry.value;
  return ExpansionTile(
  title: Text(planta,
  style: const TextStyle(fontWeight: FontWeight.bold)),
  children: extintores.map((ex) {
  return ListTile(
  leading: GestureDetector(
  onTap: () {
  showDialog(
  context: context,
  builder: (_) => Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(16),
  child: InteractiveViewer( // 👉 Permite hacer zoom y mover
  child: ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
  ex.imagen,
  fit: BoxFit.contain,
  ),
  ),
  ),
  ),
  );
  },
  child: Image.asset(
  ex.imagen,
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  ),
  ),
  title: Text(ex.descripcion),
  );

  }).toList(),
  );
  }).toList(),
  const SizedBox(height: 8),
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: const Text("Cerrar"),
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }

  =======
  >>>>>>> 39dea975ff3d553b74e69dcd6bf0d06baa25a89d
  @override
  Widget build(BuildContext context) {
  return FlutterMap(
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
  width: 20,
  height: 20,
  child: const Icon(Icons.circle, size: 15, color: Colors.red),
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
  }}

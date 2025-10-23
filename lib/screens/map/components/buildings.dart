import 'package:app_test/methods/map/fetch_buildings.dart';
import 'package:app_test/models/map/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:photo_view/photo_view.dart';

Future<List<Building>> loadBuildings() async {
  try {
    final data = await fetchBuildings(http.Client());
    return data;
  } catch (e) {
    return [];
  }
}

List<Marker> buildBuildingsMarkers(BuildContext context, List<Building> buildings) => buildings.map((building) => Marker(
  point: calcularCentroEdificio(building),
  width: 80,
  height: 60,
  child: GestureDetector(
    onTap: () => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => buildBuildingSheet(context, building),
    ),
    child: Container(color: Colors.transparent),
  ),
)).toList();

// List<Marker> buildBuildingsMarkers(BuildContext context, List<Building> buildings) => buildings.map((building) => Marker(
//   point: calcularCentroEdificio(building),
//   width: 80,
//   height: 60,
//   child: GestureDetector(
//     onTap: () => showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => buildBuildingSheet(context, building),
//     ),
//     child: Container(color: Colors.transparent),
//   ),
// )).toList();

Widget buildBuildingSheet(BuildContext context, Building building) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text(building.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          if (building.img.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(building.img, fit: BoxFit.cover, height: 180, width: double.infinity),
            ),
          const SizedBox(height: 12),
          const Divider(),
          ...building.floors.map((entry) => ExpansionTile(
            title: Text(entry.level, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: entry.equipments.map((equipment) => ListTile(
              leading: GestureDetector(
                onTap: () => _showFullPlantImage(context, equipment.img),
                child: Image.network(equipment.img, width: 50, height: 50, fit: BoxFit.cover),
              ),
              title: Text(equipment.description),
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

void _showFullPlantImage(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: PhotoView(
          imageProvider: NetworkImage(imagePath),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3.0,
        ),
      ),
    ),
  );
}

LatLng calcularCentroEdificio(Building building) {
  final latitudes = [
    building.latitude_1,
    building.latitude_2,
    building.latitude_3,
    building.latitude_4,
  ];
  final longitudes = [
    building.longitude_1,
    building.longitude_2,
    building.longitude_3,
    building.longitude_4,
  ];

  final promedioLat = latitudes.reduce((a, b) => a + b) / latitudes.length;
  final promedioLng = longitudes.reduce((a, b) => a + b) / longitudes.length;

  return LatLng(promedioLat, promedioLng);
}

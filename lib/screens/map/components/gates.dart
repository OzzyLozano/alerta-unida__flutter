
  import 'package:app_test/methods/map/fetch_gates.dart';
import 'package:app_test/models/map/gate.dart';
import 'package:app_test/components/map/bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<Gate>> loadGates() async {
  try {
    final data = await fetchGates(http.Client());
    return data;
  } catch (e) {
    return [];
  }
}

List<Marker> buildGateMarkers(BuildContext context, List<Gate> gates) => gates.map((gate) => Marker(
    point: LatLng(gate.latitude, gate.longitude),
    width: 50,
    height: 50,
    child: GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => buildGateSheet(context, gate)),
      child: const Icon(Icons.security, color: Colors.black),
    ),
  )).toList();

  Widget buildGateSheet(BuildContext context, Gate gate) => simpleBottomModal(context, gate.description, gate.img);
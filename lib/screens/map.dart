import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  LatLng? userLocation;
  final String _mapUrlTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  final LatLng _initialCoords = const LatLng(25.842444, -97.453585);

 List<String> geoJsonFiles = [
    'geojson/roads.geojson',
 ];

 @override
  void initState() {
    super.initState();
    loadGeoJsonFiles();
    getUserLocation();
  }

  GeoJsonParser myGeoJson = GeoJsonParser();
  
  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }
  Future<void> loadGeoJsonFiles() async {
    for (String file in geoJsonFiles) {
      String content = await rootBundle.loadString(file);
      myGeoJson.parseGeoJsonAsString(content);
    }
    setState(() {});
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
            const LatLng(25.83873, -97.45160)
          )
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.scrollWheelZoom,
          rotationWinGestures: 0,
          rotationThreshold: 0.0,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: _mapUrlTemplate,
        ),
        if (myGeoJson.polygons.isNotEmpty) PolygonLayer(polygons: myGeoJson.polygons,),
        if (myGeoJson.polylines.isNotEmpty) PolylineLayer(polylines: myGeoJson.polylines,),
        if (userLocation != null) 
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!, 
                child: const Icon(
                  Icons.my_location,
                  size: 12,
                )
              )
            ],
          )
        // end if
      ]
    );
  }
}

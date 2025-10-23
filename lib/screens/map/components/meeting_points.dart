
import 'package:app_test/methods/map/fetch_meeting_points.dart';
import 'package:app_test/models/map/meeting_point.dart';
import 'package:app_test/components/map/bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<MeetingPoint>> loadMeetingPoints() async {
  try {
    final data = await fetchMeetingPoints(http.Client());
    return data;
  } catch (e) {
    return [];
  }
}

List<Marker> BuildMeetingPointsMarkers(BuildContext context, List<MeetingPoint> meetingPoints) => meetingPoints.map((meetingPoint) => Marker(
    point: LatLng(meetingPoint.latitude, meetingPoint.longitude),
    width: 50,
    height: 50,
    child: GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => buildMeetingPointSheet(context, meetingPoint)),
      child: const Icon(Icons.health_and_safety, color: Colors.greenAccent),
    ),
  )
).toList();

Widget buildMeetingPointSheet(BuildContext context, MeetingPoint meetingPoint) => simpleBottomModal(context, meetingPoint.description, meetingPoint.img);

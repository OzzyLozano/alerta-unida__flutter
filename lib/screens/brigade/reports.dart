import 'dart:convert';

import 'package:app_test/components/button.dart';
import 'package:app_test/components/card.dart';
import 'package:app_test/controllers/take_picture.dart';
import 'package:app_test/models/report.dart';
import 'package:app_test/config.dart';
import 'package:app_test/screens/brigade/review_report.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url = '${AppConfig.apiUrl}/api/reports/on-wait';

Future<List<Report>> fetchReports(http.Client client) async {
  try {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseReports, response.body);
    } else {
      throw Exception('Failed to load reports');
    }
  } catch (e) {
    throw Exception('Failed to load reports: $e');
  }
}

List<Report> parseReports(String responseBody) {
  final decoded = jsonDecode(responseBody) as List<dynamic>;
  return decoded.map<Report>((json) => Report.fromJson(json)).toList();
}

class BrigadeReports extends StatefulWidget {
  const BrigadeReports({super.key});

  @override
  _BrigadeReportsState createState() => _BrigadeReportsState();
}

class _BrigadeReportsState extends State<BrigadeReports> {
  late Future<List<Report>> futureReports;
  bool isLoading = true;
  
  List<CameraDescription>? cameras;
  CameraDescription? firstCamera;

  void _refreshReports() {
    setState(() => isLoading = true);
    setState(() {
      futureReports = fetchReports(http.Client());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    futureReports = fetchReports(http.Client());
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    firstCamera = cameras!.first;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureReports, 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error has occurred: ${snapshot.error}', 
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: CmButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(camera: cameras!.first),
                        ),
                      );
                    },
                    color:  const Color.fromRGBO(120, 186, 60, 1),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 50,
                    child: const Text(
                      'Reportar emergencia',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ReportsList(
                    reports: snapshot.data!, refreshReports: _refreshReports,
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}

class ReportsList extends StatelessWidget {
  const ReportsList({super.key, required this.reports, required this.refreshReports});

  final VoidCallback refreshReports;
  final List<Report> reports;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      controller: ScrollController(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return CmCard(
          children: [
            // Imagen del reporte
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${AppConfig.apiUrl}/storage/${reports[index].img}',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            // Título
            Text(
              reports[index].title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Descripción
            Text(
              reports[index].description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            // Botón
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CmButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewReportScreen(report: reports[index]),
                      ),
                    );
                    if (result) {
                      refreshReports();
                    }
                  },
                  color: Colors.blueGrey,
                  width: 120,
                  height: 40,
                  child: const Text(
                    'Revisar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

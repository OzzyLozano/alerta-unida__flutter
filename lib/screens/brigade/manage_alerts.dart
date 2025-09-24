import 'dart:convert';

import 'package:app_test/components/alert.dart';
import 'package:app_test/components/fetch_alerts.dart';
import 'package:app_test/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class ManageAlerts extends StatefulWidget {
  const ManageAlerts({super.key});

  @override
  _ManageAlertsState createState() => _ManageAlertsState();
}

class _ManageAlertsState extends State<ManageAlerts> {
  late Future<List<Alert>> futureAlerts;
  bool isLoading = true;

  void _refreshAlerts() {
    setState(() => isLoading = true);
    setState(() {
      futureAlerts = fetchReports(http.Client());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlerts = fetchReports(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureAlerts, 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error has occurred: ${snapshot.error}', 
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AlertsList(alerts: snapshot.data!, refreshAlerts: _refreshAlerts,)
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

class AlertsList extends StatelessWidget {
  const AlertsList({super.key, required this.alerts, required this.refreshAlerts});

  final VoidCallback refreshAlerts;
  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      controller: ScrollController(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: Colors.blueAccent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      alerts[index].title,
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Text(
                      'Tipo: ${alerts[index].type}\n${alerts[index].content}\n\nEstado: ${alerts[index].status}',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await resolveAlert(alerts[index].id);
                          refreshAlerts();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size((MediaQuery.of(context).size.width - 50)/2, 35),
                          backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await cancelAlert(alerts[index].id);
                          refreshAlerts();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size((MediaQuery.of(context).size.width - 50)/2, 35),
                          backgroundColor: const Color.fromRGBO(232, 107, 23, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.do_disturb, color: Colors.white),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


Future<void> cancelAlert(int id) async {
  try {
    String url = '${AppConfig.apiUrl}/api/alerts/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'status': 'cancelled'}),
    );
    debugPrint('Cancel alert response: ${response.statusCode}: ${response.body}');
  } catch (e) {
    throw Exception('Failed to cancel alert: ${e.toString()}');
  }
}

Future<void> resolveAlert(int id) async {
  try {
    String url = '${AppConfig.apiUrl}/api/alerts/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'status': 'resolved'}),
    );
    debugPrint('Resolve alert response: ${response.statusCode}: ${response.body}');
  } catch (e) {
  throw Exception('Failed to resolve alert: ${e.toString()}');
  }
}

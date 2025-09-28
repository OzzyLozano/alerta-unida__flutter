import 'dart:convert';

import 'package:app_test/components/button.dart';
import 'package:app_test/components/card.dart';
import 'package:app_test/models/alert.dart';
import 'package:app_test/methods/fetch_alerts.dart';
import 'package:app_test/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      futureAlerts = fetchAlerts(http.Client());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    futureAlerts = fetchAlerts(http.Client());
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
    return alerts.isEmpty ? 
    // cuando no hay alertas
    const Center(
      child: Text(
        textAlign: TextAlign.center,
        'No hay alertas',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ),
    )
    // cuando hay alertas
    : ListView.builder(
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      controller: ScrollController(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return CmCard(
          children: [
            ListTile(
              title: Text(
                alerts[index].title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                'Tipo: ${alerts[index].type}\n${alerts[index].content}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                CmButton(
                  onPressed: () async {
                    await resolveAlert(alerts[index].id);
                    refreshAlerts();
                  },
                  color: const Color.fromRGBO(120, 186, 60, 1),
                  width: 100,
                  height: 40,
                  child: const Icon(Icons.check_rounded, color: Colors.white),
                ),
                const Spacer(),
                CmButton(
                  onPressed: () async {
                    await cancelAlert(alerts[index].id);
                    refreshAlerts();
                  },
                  color: const Color.fromRGBO(232, 107, 23, 1),
                  width: 100,
                  height: 40,
                  child: const Icon(Icons.do_disturb, color: Colors.white)
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 6,),
          ],
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

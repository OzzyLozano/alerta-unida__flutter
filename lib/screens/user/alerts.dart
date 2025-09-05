import 'package:app_test/components/alert.dart';
import 'package:app_test/components/fetch_alerts.dart';
import 'package:app_test/screens/checkin_form.dart'; // 👈 importa tu pantalla de check-in
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late Future<List<Alert>> futureAlerts;

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
            return AlertsList(alerts: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class AlertsList extends StatelessWidget {
  const AlertsList({super.key, required this.alerts});

  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  alert.title,
                  style: const TextStyle(fontSize: 24),
                ),
                subtitle: Text('Tipo: ${alert.type}\n${alert.content}'),
              ),
              // 👇 Mostrar botón solo si la alerta está activa (status = "active")
              if (alert.status.toLowerCase() == "active")
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinForm(
                            alertId: alert.id, // 👈 aquí pasamos el ID de la alerta
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.health_and_safety),
                    label: const Text("Realizar Check-in"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

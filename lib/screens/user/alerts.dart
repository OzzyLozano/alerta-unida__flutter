import 'package:app_test/components/alert.dart';
import 'package:app_test/components/fetch_alerts.dart';
import 'package:app_test/screens/brigade/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late Future<List<Alert>> futureAlerts;
  bool isLoading = true;

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
        }
      )
    );
  }
}

class AlertsList extends StatelessWidget {
  const AlertsList({super.key, required this.alerts});

  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      controller: ScrollController(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(alerts[index].title, style: const TextStyle(fontSize: 24),),
            subtitle: Text('Tipo: ${alerts[index].type}\n${alerts[index].content}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(alertId: alerts[index].id),
                ),
              );
            }
          ),
        );
      }
    );
  }
}

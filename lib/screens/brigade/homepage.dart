import 'package:app_test/components/card.dart';
import 'package:app_test/models/alert.dart';
import 'package:app_test/methods/fetch_alerts.dart';
import 'package:app_test/screens/brigade/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BrigadeHome extends StatefulWidget {
  const BrigadeHome({super.key});

  @override
  _BrigadeHomeState createState() => _BrigadeHomeState();
}

class _BrigadeHomeState extends State<BrigadeHome> {
  late Future<List<Alert>> futureAlerts;
  bool isLoading = true;

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
                'Chat: ${alerts[index].title}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                'Tipo: ${alerts[index].type}\n${alerts[index].content}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => ChatScreen(alertId: alerts[index].id),
                  ),
                );
              }
            ),
          ]
        );
      }
    );
  }
}

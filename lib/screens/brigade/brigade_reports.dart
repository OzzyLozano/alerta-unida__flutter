import 'dart:convert';

import 'package:app_test/components/report.dart';
import 'package:app_test/config.dart';
import 'package:app_test/screens/brigade/review_report.dart';
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReportsList(reports: snapshot.data!, refreshReports: _refreshReports,)
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
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      controller: ScrollController(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.network(
                '${AppConfig.apiUrl}/storage/${reports[index].img}',
                width: MediaQuery.of(context).size.width - 20,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(reports[index].title, style: const TextStyle(fontSize: 24),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 16),
              child: Text(reports[index].description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewReportScreen(report: reports[index]),
                      ),
                    );

                    if (result == true) {
                      refreshReports();
                    }
                  },
                  child: const Text('Revisar'),
                )
              ],
            )
          ]
        );
      }
    );
  }
}

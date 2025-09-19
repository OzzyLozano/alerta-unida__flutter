import 'dart:convert';
import 'dart:io';

import 'package:app_test/components/report.dart';
import 'package:app_test/config.dart';
import 'package:app_test/homepage.dart';
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
                  child: ElevatedButton(
                    onPressed: cameras == null
                    ? null
                    : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(camera: cameras!.first),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
                      backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                      child: Text(
                        'Reportar emergencia',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),
                ),
                Expanded(
                  child: ReportsList(reports: snapshot.data!, refreshReports: _refreshReports,),
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

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}
class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar emergencia')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
          backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación de imágen')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayForm(image_path: imagePath,)
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
                  backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
          ),
        ],
      ),
    );
  }
}

class DisplayForm extends StatelessWidget {
  final image_path;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DisplayForm({super.key, this.image_path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar reporte')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enviando reporte...')),
                          );
                          await sendReport(
                            context,
                            image_path,
                            _titleController.text,
                            _descriptionController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
                        backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> sendReport(BuildContext context, String imagePath, String title, String description) async {
  try {
    final uri = Uri.parse('${AppConfig.apiUrl}/api/reports/send-report');
    
    var request = http.MultipartRequest('POST', uri);
    
    var file = await http.MultipartFile.fromPath('img', imagePath);
    request.files.add(file);
    
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['user_id'] = '1';

    var response = await request.send();
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado exitosamente!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      print('Respuesta: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

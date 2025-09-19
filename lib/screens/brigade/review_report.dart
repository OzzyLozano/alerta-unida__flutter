import 'dart:convert';

import 'package:app_test/components/report.dart';
import 'package:app_test/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewReportScreen extends StatefulWidget {
  final Report report;
  const ReviewReportScreen({super.key, required this.report});

  @override
  _ReviewReportScreenState createState() => _ReviewReportScreenState();
}

class _ReviewReportScreenState extends State<ReviewReportScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  final List<String> _types = [
    'evacuacion',
    'prevencion/combate de fuego',
    'busqueda y rescate',
    'primeros auxilios'
  ];
  
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    // Inicializamos con los valores originales del reporte
    _titleController = TextEditingController(text: widget.report.title);
    _descriptionController = TextEditingController(text: widget.report.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Revisión de Reporte")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('${AppConfig.apiUrl}/storage/${widget.report.img}'),
            const SizedBox(height: 24),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de reporte',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Aceptar"),
                  onPressed: () async {
                    await authorizeReport(
                      context: context,
                      widget.report.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      type: _selectedType,
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Cancelar"),
                  onPressed: () async {
                    await cancelReport(context: context, widget.report.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> authorizeReport(int reportId, {required BuildContext context, required String title, required String description, String? type}) async {
  try {
    if (title == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor agregue un titulo')),
      );
      return;
    } if (description == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor agregue una descripción')),
      );
      return;
    } if (type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un tipo de reporte')),
      );
      return;
    } else {
      final response = await http.put(
        Uri.parse('${AppConfig.apiUrl}/api/reports/$reportId/authorize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'type': type,
        }),
      );
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El reporte ha sido enviado como alerta')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Response Status: ${response.statusCode}')),
        );
      }
      Navigator.pop(context, true);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}

Future<void> cancelReport(int reportId, {required BuildContext context}) async {
  try {
    final response = await http.put(
      Uri.parse('${AppConfig.apiUrl}/api/reports/$reportId/cancel'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El reporte ha sido cancelado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response Status: ${response.statusCode}')),
      );
    }
    Navigator.pop(context, true);
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}

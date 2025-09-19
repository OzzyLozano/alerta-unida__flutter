import 'dart:convert';
import 'package:app_test/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckinForm extends StatefulWidget {
  final int alertId;

  const CheckinForm({
    Key? key,
    required this.alertId,
  }) : super(key: key);

  @override
  State<CheckinForm> createState() => _CheckinFormState();
}

class _CheckinFormState extends State<CheckinForm> {
  final _formKey = GlobalKey<FormState>();
  int? _meetingPoint;
  String? _areYouOkay;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Si tu app guardó userName/userEmail en SharedPreferences, los añadimos (opcional)
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('userName');
      final savedEmail = prefs.getString('userEmail');

      final Map<String, dynamic> payload = {
        'alert_id': widget.alertId,
        'meeting_point': _meetingPoint,
        'are_you_okay': _areYouOkay,
      };

      if (savedName != null && savedName.isNotEmpty) {
        payload['name'] = savedName;
      }
      if (savedEmail != null && savedEmail.isNotEmpty) {
        payload['email'] = savedEmail;
      }

      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}/api/check_in/storeApi"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      String serverMsg = 'Check-in registrado';
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data['message'] is String) {
          serverMsg = data['message'];
        }
      } catch (_) {
        // Si la respuesta no es JSON válido, usamos el mensaje por defecto
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(serverMsg)),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(serverMsg.isNotEmpty ? serverMsg : 'Error al registrar')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check-in")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _meetingPoint,
                  decoration: const InputDecoration(labelText: "Punto de reunión"),
                  items: List.generate(
                    4,
                        (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text("Punto ${i + 1}"),
                    ),
                  ),
                  onChanged: (val) => setState(() => _meetingPoint = val),
                  validator: (value) => value == null ? "Selecciona un punto de reunión" : null,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _areYouOkay,
                  decoration: const InputDecoration(labelText: "¿Estás bien?"),
                  items: const [
                    DropdownMenuItem(value: "Si", child: Text("Sí")),
                    DropdownMenuItem(value: "No", child: Text("No")),
                  ],
                  onChanged: (val) => setState(() => _areYouOkay = val),
                  validator: (value) => value == null ? "Selecciona una opción" : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Confirmar asistencia", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

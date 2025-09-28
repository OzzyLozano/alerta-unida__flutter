import 'dart:convert';
import 'package:app_test/components/button.dart';
import 'package:app_test/config.dart';
import 'package:app_test/services/fcm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_test/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = '${AppConfig.apiUrl}/flutter/brigade-login';

class BrigadeLogin extends StatefulWidget {
  const BrigadeLogin ({super.key});

  @override
  State<BrigadeLogin> createState() => _BrigadeLoginState();
}

class _BrigadeLoginState extends State<BrigadeLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      final success = await validateUser(http.Client(), email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        goToHome();
      }
    }
  }

  void goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<bool> validateUser(http.Client client, String email, String password) async {
    final url = Uri.parse(apiUrl);
    final preferences = await SharedPreferences.getInstance();

    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        int brigadeId = data['brigade_user']['id'];

        await preferences.setBool('isLogin', true);
        await preferences.setInt('userId', brigadeId);
        await preferences.setBool('isBrigadeMember', true);

        await FCM.refreshTokenRelationship();
        await FCM.getAndSendToken();

        setState(() {
          message = 'Sesión de brigadista iniciada!';
        });

        return true;
      } else {
        final errorMsg = jsonDecode(response.body)['message'];
        preferences.setBool('isLogin', false);
        preferences.setBool('isBrigadeMember', false);
        setState(() {
          message = errorMsg;
        });
        return false;
      }
    } catch (e) {
      preferences.setBool('isLogin', false);
        preferences.setBool('isBrigadeMember', false);
      setState(() {
        message = 'Error de conexión o inesperado.';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicia Sesión'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico"
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña"
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Center(
                  child: CmButton(
                    onPressed: () {
                      login();
                    },
                    color: const Color.fromRGBO(232, 107, 23, 1),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 50,
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

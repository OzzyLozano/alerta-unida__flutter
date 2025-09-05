import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_test/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://10.0.2.2:8000/flutter/brigade-login';

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

      if (response.statusCode == 200) {
        preferences.setBool('isLogin', true);
        preferences.setBool('isBrigadeMember', true);

        setState(() {
          message = 'Sesión iniciada!';
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
                  child: ElevatedButton(
                    onPressed: () {
                      login();
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
                        'Iniciar Sesión como brigadista',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
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

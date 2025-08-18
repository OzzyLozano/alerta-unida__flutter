import 'package:app_test/config.dart';
import 'package:app_test/splashscreen/login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = '${AppConfig.apiUrl}/api/users';
String message = '';

Future<void> registerUser(String name, String lastname, String email, String password, String userType, BuildContext context) async {
  final url = Uri.parse(apiUrl);
  final headers = {
    'Content-Type': 'application/json',
  };
  // Send the registration request
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode({
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
      'type': userType,
    }),
  );

  final Map<String, dynamic> body = jsonDecode(response.body);
  if (response.statusCode == 201) {
    message = body['message'] as String? ?? 'Usuario registrado exitosamente';
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
  } else {
    message = body['message'] as String? ?? 'Error al registrar el usuario'; 
    message += body['error'] as String? ?? '';
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final String _userType = 'estudiante';

  bool nameValidated = false;
  bool lastnameValidated = false;
  bool emailValidated = false;
  bool passwordValidated = false;

  // animation
  double animationDuration = 300;
  double currentPage = 1;
  void changePage(double page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    nameValidated = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nombre(s)',
                  suffixIcon: Icon(
                    Icons.check_circle_outline,
                    color: nameValidated
                      ? const Color.fromARGB(255, 101, 240, 106)
                      : Colors.grey,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastnameController,
                onChanged: (value) {
                  setState(() {
                    lastnameValidated = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  suffixIcon: Icon(
                    Icons.check_circle_outline,
                    color: lastnameValidated
                      ? const Color.fromARGB(255, 101, 240, 106)
                      : Colors.grey,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _userType,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(
                    value: 'maestro',
                    child: Text('Maestro'),
                  ),
                  DropdownMenuItem(
                    value: 'estudiante',
                    child: Text('Estudiante'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) { }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione un tipo de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    emailValidated = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  suffixIcon: Icon(
                    Icons.check_circle_outline,
                    color: emailValidated
                      ? const Color.fromARGB(255, 101, 240, 106)
                      : Colors.grey,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su correo electrónico';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    passwordValidated = value.length >= 8;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: Icon(
                    Icons.check_circle_outline,
                    color: passwordValidated
                      ? const Color.fromARGB(255, 101, 240, 106)
                      : Colors.grey,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una contraseña';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerUser(
                    _nameController.text,
                    _lastnameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _userType,
                    context
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
                  backgroundColor: const Color.fromRGBO(27, 113, 160, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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

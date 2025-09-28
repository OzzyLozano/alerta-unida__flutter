import 'package:app_test/main_page.dart';
import 'package:flutter/material.dart';
import './welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> with SingleTickerProviderStateMixin {
  //variables de uso
  bool blateral = false;
  final TextEditingController controladorCorreo = TextEditingController();

  ///datos a tratar
  final TextEditingController controladorTelefono = TextEditingController();
  final TextEditingController controladorCarrera = TextEditingController();
  final TextEditingController controladorNoControl = TextEditingController();
  final TextEditingController controladorUsuario = TextEditingController();
  bool validarCorreo = false;
  bool validarTelefono = false;
  bool validarCarrera = false;
  bool validarNoControl = false;
  bool validarUsuario = false;
  //animacion de movimiento
  bool circuloanimacion = true;
  void accionanimacion() {
    setState(() {
      circuloanimacion = !circuloanimacion;
    });
  }

  //checar el movimiento y velocidad
  @override
  Widget build(BuildContext context) {
    double widthbl = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(230, 245, 245, 245),
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: circuloanimacion ? 65 : 50,
              height: circuloanimacion ? 65 : 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(70, 0, 0, 0),
                  width: 3
                ),
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 3,
              color: Colors.black,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: circuloanimacion ? 50 : 65,
              height: circuloanimacion ? 50 : 65,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromARGB(70, 0, 0, 0), width: 3),
              ),
              child: const Center(
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Por favor, ingrese la información solicitada.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controladorCarrera,
                              onChanged: (value) {
                                setState(() {
                                  validarCarrera = value.length >= 5;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check_circle_outline,
                                  color: validarCarrera
                                    ? const Color.fromARGB(255, 101, 240, 106)
                                    : Colors.grey,
                                ),
                                label: const Text(
                                  'Carrera',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: controladorNoControl,
                              onChanged: (value) {
                                setState(() {
                                  validarNoControl = value.length >= 5;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check_circle_outline,
                                  color: validarNoControl
                                    ? const Color.fromARGB(255, 101, 240, 106)
                                    : Colors.grey,
                                ),
                                label: const Text(
                                  'Numero de control',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: controladorUsuario,
                              onChanged: (value) {
                                setState(() {
                                  validarUsuario = value.length >= 5;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check_circle_outline,
                                  color: validarUsuario
                                    ? const Color.fromARGB(255, 101, 240, 106)
                                    : Colors.grey,
                                ),
                                label: const Text(
                                  'Nombre de usuario',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              )
                            )
                          ]
                        )
                      )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage()
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(173, 216, 230, 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continuar',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ),
        // Barra lateral deslizable
        //Formulario-2
        AnimatedPositioned(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: blateral ? 0 : -widthbl,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                border: Border.all(color: Colors.black),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Por favor, ingresa tus datos para continuar.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: Color.fromARGB(255, 102, 102, 102)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: controladorCorreo,
                        onChanged: (value) {
                          setState(() {
                            validarCorreo = value.length >= 5;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check_circle_outline,
                            color: validarCorreo
                              ? const Color.fromARGB(255, 101, 240, 106)
                              : Colors.grey,
                          ),
                          label: const Text(
                            'Correo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: controladorTelefono,
                        onChanged: (value) {
                          setState(() {
                            validarTelefono = value.length >= 5;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check_circle_outline,
                            color: validarTelefono
                              ? const Color.fromARGB(255, 101, 240, 106)
                              : Colors.grey,
                          ),
                          label: const Text(
                            'Número de teléfono',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Contra(), //llamada a la clase de passowrd
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            blateral = true;
                            accionanimacion();
                          });
                        },
                        child: Container(
                          height: 58,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black),
                            color: const Color.fromRGBO(144, 238, 144, 1),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Siguiente',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                color: Colors.black,
                                size: 33,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Ya tienes Cuenta?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                  );
                                },
                                child: const Text("Iniciar Sesion",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  )
                                )
                              )
                            ]
                          )
                        )
                      ]
                    )
                  )
                )
        ),
      ],
    ));
  }
}

//animaciond e password, y mostreo de contra
class Contra extends StatefulWidget {
  const Contra({Key? key}) : super(key: key);

  @override
  _ContraState createState() => _ContraState();
}

class _ContraState extends State<Contra> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 0.0),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            label: const Text(
              'Contraseña',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Confirma
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 0.0),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            label: const Text(
              'Confirmar Contraseña',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            errorText: _errorMessage,
          ),
          onChanged: (value) {
            _validatePasswords();
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

//validar
  bool _validatePasswords() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Las contraseñas es diferente";
      });
      return false;
    } else {
      setState(() {
        _errorMessage = null;
      });
      return true;
    }
  }
}

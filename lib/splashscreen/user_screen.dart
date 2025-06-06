import 'package:app_test/splashscreen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart';
import './nivel_expansion.dart';

class UserSC extends StatefulWidget {
  final String usercorreo;
  final String usernombre;
  final String usertelefono;
  final String usercarrera;
  final String usercontrol;
  const UserSC({
    super.key,
    required this.usercorreo,
    required this.usernombre,
    required this.usertelefono,
    required this.usercarrera,
    required this.usercontrol,
  });
  @override
  _UserSC createState() => _UserSC();
}

class _UserSC extends State<UserSC> {
  void logout() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isLogin', false);
    preferences.setBool('isBrigadeMember', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(230, 245, 245, 245),
                    Color.fromARGB(255, 248, 248, 248),
                  ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          listaespecial(
                            principal: widget.usernombre,
                            secundario: widget.usercontrol,
                          ),
                          listanombre("Correo"),
                          listaobjetos(
                            icono: Icons.email,
                            titulo: widget.usercorreo,
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 102, 102, 102),
                            thickness: 1,
                          ),
                          listanombre("Teléfono"),
                          listaobjetos(
                            icono: Icons.phone,
                            titulo: widget.usertelefono,
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 102, 102, 102),
                            thickness: 1,
                          ),
                          listanombre("Carrera"),
                          listaobjetos(
                            icono: Icons.school,
                            titulo: widget.usercarrera,
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 102, 102, 102),
                            thickness: 1,
                          ),
                          listanombre("Contraseña"),
                          listaobjetos(
                            icono: Icons.lock,
                            titulo: widget.usercorreo,
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 102, 102, 102),
                            thickness: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 58,
                        width: 340,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 70, 168, 55),
                            width: 4.0,
                          ),
                          color: const Color.fromARGB(230, 245, 245, 245),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Emergencia Reportadas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NivelExpansion(),
                          ),
                        );
                      },
                      child: Container(
                        height: 58,
                        width: 340,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 70, 168, 55),
                            width: 4,
                          ),
                          color: const Color.fromARGB(230, 245, 245, 245),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Niveles de emergencia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: logout, 
                child: const Text('Cerrar Sesión')
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listaespecial({
    required String principal,
    required String secundario,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            principal,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            secundario,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget listanombre(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget listaobjetos({
    required IconData icono,
    required String titulo,
  }) {
    return ListTile(
      leading: Icon(icono, color: Colors.black),
      title: titulo.isNotEmpty
          ? Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold))
          : null,
    );
  }
}

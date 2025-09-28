import 'package:app_test/auth/brigade_login.dart';
import 'package:app_test/auth/login.dart';
import 'package:app_test/components/button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  //checar, el uso de invitado,registro, inicio sesion

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoSize = screenWidth > 440 ? screenWidth > 540 ? screenWidth/4 : screenWidth/3 : screenWidth/2;
    double buttonWidth = screenWidth > 440 ? screenWidth > 540 ? screenWidth/3 : screenWidth/2 : screenWidth - 20;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(230, 245, 245, 245),
            Color.fromARGB(255, 248, 248, 248),
          ]),
        ),
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image(
                image: const AssetImage('assets/alerta_unida_isotipo.png'),
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //cambiar TEXTO, algo diferente
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CmButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  builder: (BuildContext context) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        const Text(
                          textAlign: TextAlign.center,
                          '¿Eres brigadista o usuario?',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: CmButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                            },
                            color: const Color.fromRGBO(120, 186, 60, 1),
                            width: buttonWidth,
                            height: 50,
                            child: const Text(
                              'Usuario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: CmButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BrigadeLogin()));
                            },
                            color: const Color.fromRGBO(232, 107, 23, 1),
                            width: buttonWidth,
                            height: 50,
                            child: const Text(
                              'Brigadista',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                );
              },
              color: const Color.fromRGBO(120, 186, 60, 1),
              width: buttonWidth,
              height: 50,
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'O',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            CmButton(
              onPressed: () {},
              color: const Color.fromRGBO(27, 113, 160, 1),
              width: buttonWidth,
              height: 50,
              child: const Text(
                'Entrar como invitado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'TecNM_Matamoros',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

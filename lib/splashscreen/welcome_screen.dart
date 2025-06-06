import 'package:app_test/auth/register.dart';
import 'package:app_test/splashscreen/login.dart';
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
            ElevatedButton(
              onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(buttonWidth, 50),
                backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Inicia Sesión',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
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
            ElevatedButton(
              onPressed: () { 
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(buttonWidth, 50),
                backgroundColor: const Color.fromRGBO(27, 113, 160, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Regístrate',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
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

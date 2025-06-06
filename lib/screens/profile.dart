import 'package:app_test/splashscreen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void logout() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isLogin', false);
    preferences.setBool('isBrigadeMember', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Center(
            child: ElevatedButton(
              onPressed: logout, 
              child: const Text('Cerrar Sesión')
            ),
          )
        )
      ],
    );
  }
}

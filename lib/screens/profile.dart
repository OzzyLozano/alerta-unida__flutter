import 'package:app_test/services/fcm.dart';
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
    await preferences.remove('userId');
    await preferences.remove('isLogin');
    await preferences.remove('isBrigadeMember');
    await FCM.removeToken();
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

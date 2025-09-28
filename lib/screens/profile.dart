import 'package:app_test/components/button.dart';
import 'package:app_test/components/card.dart';
import 'package:app_test/methods/fetch_user.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/fcm.dart';
import 'package:app_test/splashscreen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> futureUser;

  void logout() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('userId');
    await preferences.remove('isLogin');
    await preferences.remove('isBrigadeMember');
    await FCM.removeToken();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }
  
  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error has occurred: ${snapshot.error}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Column(
              children: [
                CmCard(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 40,
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: Text(
                            '${userData.name} ${userData.lastname}',
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                CmCard(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          size: 40,
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: Text(
                            userData.email,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                CmCard(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 40,
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: Text(
                            userData.phone!.isEmpty 
                              ? 'No hay un teléfono asociado' 
                              : userData.phone!,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Center(
                    child: Column(
                      children: [
                        CmButton(
                          onPressed: logout,
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width - 20,
                          height: 40,
                          child: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

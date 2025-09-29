import 'package:app_test/components/button.dart';
import 'package:app_test/components/card.dart';
import 'package:app_test/methods/fetch_brigade_member.dart';
import 'package:app_test/models/brigade_member.dart';
import 'package:app_test/services/fcm.dart';
import 'package:app_test/splashscreen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BrigadeProfile extends StatefulWidget {
  const BrigadeProfile({super.key});
  
  @override
  State<BrigadeProfile> createState() => _BrigadeProfileState();
}

class _BrigadeProfileState extends State<BrigadeProfile> {
  late Future<BrigadeMember> futureBrigadeMember;

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
    futureBrigadeMember = fetchBrigadeMember(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureBrigadeMember,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error has occurred: ${snapshot.error}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            final brigadeMemberData = snapshot.data!;
            return ListView(
              children: [
                CmCard(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${brigadeMemberData.name} ${brigadeMemberData.lastname}',
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            brigadeMemberData.email,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            brigadeMemberData.phone!.isEmpty 
                              ? 'No hay un teléfono asociado' 
                              : brigadeMemberData.phone!,
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
                          Icons.man,
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            brigadeMemberData.role == 'miembro' ? 'Brigadista' : 'Líder',
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
                    ListTile(
                      title: const Text(
                        'Capacitaciones',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: brigadeMemberData.training.map((capacitacion) {
                          return Text(
                            capacitacion,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          );
                        }).toList(),
                      )
                    ),
                  ],
                ),
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

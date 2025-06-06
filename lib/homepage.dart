import 'package:app_test/screens/alerts.dart';
import 'package:app_test/screens/brigade_reports.dart';
import 'package:app_test/screens/home.dart';
import 'package:app_test/screens/map.dart';
import 'package:app_test/screens/user_reports.dart';
import 'package:app_test/splashscreen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    NavigationDestination(
      selectedIcon: Icon(Icons.notifications_outlined),
      icon: Badge(child: Icon(Icons.notifications)),
      label: 'Alertas',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.fmd_good_outlined),
      icon: Icon(Icons.fmd_good), 
      label: 'Mapa',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.home_outlined),
      icon: Icon(Icons.home),
      label: 'Inicio',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.account_circle_outlined),
      icon: Icon(Icons.account_circle),
      label: 'Perfil',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.health_and_safety_outlined),
      icon: Icon(Icons.health_and_safety), 
      label: 'Reportes',
    ),
  ];
  static const List<Widget> appTitle = <Widget>[
    Text('Alertas', style: TextStyle(fontSize: 32,),),
    Text('Mapa', style: TextStyle(fontSize: 32,),),
    Text('Inicio', style: TextStyle(fontSize: 32,),),
    Text('Perfil', style: TextStyle(fontSize: 32,),),
    Text('Reportes', style: TextStyle(fontSize: 32,),),
  ];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xe6f5f5f5),
        title: appTitle[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          onTapped(index);
        },
        destinations: _widgetOptions,
        selectedIndex: _selectedIndex,
        height: 80,
        ),
      body: <Widget>[
        const Alerts(),
        const OSMMap(),
        const Home(),
        const UserSC(usercorreo: 'usercorreo', usernombre: 'usernombre', usertelefono: 'usertelefono', usercarrera: 'usercarrera', usercontrol: 'usercontrol'),
        (preferences.getBool('isBrigadeMember') ?? false) ? const BrigadeReports() : const UserReports()
      ][_selectedIndex],
    );
  }
}

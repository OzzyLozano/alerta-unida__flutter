import 'package:app_test/screens/brigade/profile.dart';
import 'package:app_test/screens/user/profile.dart';
import 'package:app_test/screens/user/alerts.dart';
import 'package:app_test/screens/brigade/homepage.dart';
import 'package:app_test/screens/brigade/reports.dart';
import 'package:app_test/screens/brigade/alerts.dart';
import 'package:app_test/screens/map.dart';
import 'package:app_test/screens/user/homepage.dart';
import 'package:app_test/screens/user/reports.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  SharedPreferences? preferences;

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
  static const List<String> appTitlesText = [
    'Alertas',
    'Mapa',
    'Bienvenido/a',
    'Perfil',
    'Reportes',
  ];

  static final List<Widget> appTitle = appTitlesText.map((title) {
    return Text(
      title,
      textAlign: TextAlign.center,
    );
  }).toList();
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  bool get isBrigade => preferences?.getBool('isBrigadeMember') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
        isBrigade ? 
        const ManageAlerts() : const Alerts(),
        const OSMMap(),
        isBrigade ? 
        const BrigadeHome() : const UserHome(),
        isBrigade ? 
        const BrigadeProfile() : const UserProfile(),
        isBrigade ? 
        const BrigadeReports() : const UserReports()
      ][_selectedIndex],
    );
  }
}

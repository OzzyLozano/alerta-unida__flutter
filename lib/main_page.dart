import 'package:app_test/screens/brigade/profile.dart';
import 'package:app_test/screens/user/profile.dart';
import 'package:app_test/screens/user/alerts.dart';
import 'package:app_test/screens/brigade/homepage.dart';
import 'package:app_test/screens/brigade/reports.dart';
import 'package:app_test/screens/brigade/alerts.dart';
import 'package:app_test/screens/map/map.dart';
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



  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {});

  }
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get isBrigade => preferences?.getBool('isBrigadeMember') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      appBar: _selectedIndex == 1
      ? null
      : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          _selectedIndex == 2
              ? 'Bienvenido/a'
              : _selectedIndex == 0
              ? 'Alertas'
              : _selectedIndex == 3
              ? 'Perfil'
              : 'Reportes',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 3,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onTapped,
        selectedIndex: _selectedIndex,
        height: 80,
        destinations: const [
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
        ],
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
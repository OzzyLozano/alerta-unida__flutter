import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome ({super.key});
  
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  static final SliverChildBuilderDelegate _sliverEmergencyOptions = SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return _emergencyOptions[index];
    },
    childCount: _emergencyOptions.length,
  );
  static final List<Widget> _emergencyOptions = <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.red,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.white,
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.indigo,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.white,
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.orange.shade900,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.white,
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.green.shade600,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.white,
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.black,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imgSize = screenWidth < 264 ? 120 : 160;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: imgSize < 10 ? 0 : 10),
                    child: Image.asset(
                      'assets/alerta_unida_isotipo.png',
                      width: imgSize,
                      height: imgSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '¿Cuál es su emergencia?',
                      style: TextStyle(
                        fontSize: screenWidth < 264 ? 20 : 24,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: _sliverEmergencyOptions
          ),
        ],
      )
    );
  }
}

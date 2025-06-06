import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home ({super.key});
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final List<Widget> _emergencyOptions = <Widget>[
    Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.red,
      ),
      child: const Icon(
        Icons.emergency,
        color: Colors.white,
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imgSize = screenWidth < 264 ? 120 : 160;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth,
            height: screenWidth < 264 ? screenWidth < 220 ? 220 : 200 : 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: imgSize < 20 ? 0 : 20),
                  child: Image(
                    image: const AssetImage('assets/alerta_unida_isotipo.png'),
                    width: imgSize,
                    height: imgSize,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  '¿Cuál es su emergencia?',
                  style: TextStyle(
                    fontSize: screenWidth < 264 ? 20 : 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: screenWidth > 264 ? screenWidth > 360 ? screenWidth > 440 ? screenWidth > 540 ? screenWidth > 768 ? screenWidth/4 : screenWidth/5 : 40 : 20 : 10 : 5,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [..._emergencyOptions],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

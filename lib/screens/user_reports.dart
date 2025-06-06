import 'package:flutter/material.dart';

class UserReports extends StatefulWidget {
  const UserReports({super.key});

  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              'Reporta una emergencia',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proximamente...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width - 20, 50),
                  backgroundColor: const Color.fromRGBO(120, 186, 60, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                  child: Text(
                    'Tomar foto c:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
            ),
          ),
        ]
      )
    );
  }
}

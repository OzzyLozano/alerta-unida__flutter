import 'package:app_test/components/button.dart';
import 'package:app_test/controllers/take_picture.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class UserReports extends StatefulWidget {
  const UserReports({super.key});

  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  bool isLoading = true;
  
  List<CameraDescription>? cameras;
  CameraDescription? firstCamera;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    firstCamera = cameras!.first;
    setState(() {
      isLoading = false;
    });
  }

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
              child: CmButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePictureScreen(camera: cameras!.first),
                    ),
                  );
                },
                color: const Color.fromRGBO(120, 186, 60, 1),
                width: MediaQuery.of(context).size.width - 20,
                height: 50,
                child: const Text(
                  'Reportar emergencia',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}

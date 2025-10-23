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

  Widget _buildAlertSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(204, 255, 204, 1), // Tono verde claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Ocurrio un accidente o hay una situación que requiera accion inmediata ?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReportFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(220, 238, 255, 1), // Tono azul claro
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Icono del lápiz y papel (Ajustado para que se vea similar)
          const Center(
            child: Icon(
              Icons.edit_note,
              size: 60,
              color: Color.fromRGBO(70, 130, 180, 1),
            ),
          ),
          const SizedBox(height: 10),

          // Título principal
          const Center(
            child: Text(
              'Genera un Reporte',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Texto
          const Text(
            'Incluyendo una fotografía',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          const Text(
            'Incluye un Titulo',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          const Text(
            'Incluye una Descripción',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),


          // Botón de Reportar Emergencia
          CmButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TakePictureScreen(camera: cameras!.first),
                ),

              );
            },
            color: Colors.green, // Fondo negro
            width: double.infinity,
            height: 50,
            child: const Text(
              'Reportar Emergencia',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 240, 210, 1), // Tono amarillo/marrón claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'INFORMACIÓN ADICIONAL:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Los reportes son revisados por los brigadistas los cuales son los encargados de determinar el nivel de riesgo que pueda representar la emergencia o si se requiere tomar alguna accion inmediata.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Sección de Pregunta/Alerta Verde
            _buildAlertSection(),

            const SizedBox(height: 20),

            // Sección de Generación de Reporte (Azul)
            _buildReportFormSection(),

            const SizedBox(height: 20),

            // Sección de Información Adicional (Amarilla/Marrón)
            _buildAdditionalInfoSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}

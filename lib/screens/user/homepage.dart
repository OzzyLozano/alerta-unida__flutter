import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome ({super.key});
  
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // Datos de cada chaleco (se mantiene igual)
  final List<Map<String, String>> brigades = [
    {
      'image': 'assets/chalecorojo.png',
      'label': 'Incendios',
      'title': 'Brigada de Incendios',
      'subtitle': 'Prevención y control',
      'body': 'Encargados de apagar incendios y mantener la seguridad en zonas de riesgo.',
    },
    {
      'image': 'assets/chalecoazul.png',
      'label': 'Rescate',
      'title': 'Brigada de Rescate',
      'subtitle': 'Auxilio y salvamento',
      'body': 'Especialistas en rescatar personas en situaciones de emergencia.',
    },
    {
      'image': 'assets/chaleco-naranja.png',
      'label': 'Evacuación',
      'title': 'Brigada de Evacuación',
      'subtitle': 'Organización y guía',
      'body': 'Se encargan de evacuar zonas de peligro de manera segura.',
    },
    {
      'image': 'assets/chalecoblanco.png',
      'label': 'Primeros Auxilios',
      'title': 'Brigada de Primeros Auxilios',
      'subtitle': 'Atención inmediata',
      'body': 'Proporcionan asistencia médica inicial en emergencias.',
    },
    {
      'image': 'assets/chalecoverde.png',
      'label': 'Comunicación',
      'title': 'Brigada de Comunicación',
      'subtitle': 'Coordinación y soporte',
      'body': 'Mantienen la comunicación entre todas las brigadas y alertan sobre emergencias.',
    },
  ];

  final double imageWidth = 130;
  final double imageHeight = 150;

  final double gridSpacing = 8;
  final Color dividerColor = Colors.black12;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imgSize = screenWidth < 264 ? 120 : 160;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Container(
              height: imgSize + 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Image.asset(
                  'assets/LogoAlertaUnida.png',
                  width: imgSize + 20,
                  height: imgSize + 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'BRIGADAS DE EMERGENCIA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(thickness: 1.2, color: Colors.black12),
            const SizedBox(height: 16),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4, // Solo mostramos los primeros 4 elementos
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // Ajusta la relación de aspecto para que el alto sea mayor que el ancho
                childAspectRatio: 0.8,
                // Usamos el espaciado para que haya un hueco entre los elementos
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing,
              ),
              itemBuilder: (context, index) {
                // Aquí aplicamos un separador vertical condicional
                return _buildGridItemWithDivider(context, index);
              },
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0), // Padding para centrar visualmente
              child: _buildBrigadeButton(context, 4),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGridItemWithDivider(BuildContext context, int index) {
    return Container(
      // Condición: Si es el elemento 0 o 2 (lado izquierdo), agregamos un borde DERECHO
      // Esto crea la línea central visible.
      decoration: BoxDecoration(
        border: index % 2 == 0
            ? Border(right: BorderSide(color: dividerColor, width: 1.5))
            : null,
      ),
      // El padding asegura que el botón no se pegue al borde (la línea)
      padding: index % 2 == 0
          ? const EdgeInsets.only(right: 8) // Padding a la derecha para elementos izquierdos
          : const EdgeInsets.only(left: 8), // Padding a la izquierda para elementos derechos
      child: _buildBrigadeButton(context, index),
    );
  }

  Widget _buildBrigadeButton(BuildContext context, int index) {
    final brigade = brigades[index];

    // Contenedor principal para el botón de chaleco (la "tarjeta")
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showBrigadeDialog(context, brigade),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              brigade['image']!,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              brigade['label']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBrigadeDialog(BuildContext context, Map<String, String> brigade) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 12,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                brigade['image']!,
                width: 150,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                brigade['title']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                brigade['subtitle']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                brigade['body']!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }

}

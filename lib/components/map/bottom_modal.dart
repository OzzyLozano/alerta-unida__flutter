import 'package:flutter/material.dart';

Widget simpleBottomModal(BuildContext context, String nombre, String imagen) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      if (imagen.isNotEmpty)
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 360,
                maxHeight: 200,
              ),
              child: Image.network(imagen, fit: BoxFit.contain, height: double.infinity, width: double.infinity),
            ),
          ),
        ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
      )
    ]),
  );
}

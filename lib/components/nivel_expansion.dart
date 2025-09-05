import 'package:flutter/material.dart';

class NivelExpansion extends StatefulWidget {
  const NivelExpansion({super.key});

  @override
  _NivelExpansionState createState() => _NivelExpansionState();
}

class _NivelExpansionState extends State<NivelExpansion> {
  final List<Item> _items = [
    Item(
      header: "Nivel 1",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis gravida eros, at luctus arcu luctus et. Integer cursus libero nec nulla cursus, et aliquet odio placerat. Nam vestibulum, nulla ut laoreet facilisis, ligula sem cursus libero, vel pulvinar nisi arcu nec sapien. Nullam tristique urna a erat venenatis, nec interdum risus bibendum. Curabitur in risus vitae lacus egestas fermentum. Phasellus at semper lorem. Integer in libero ut felis pharetra faucibus. Nunc volutpat lacus at ex posuere, a varius erat ultrices. Aenean elementum suscipit neque, non scelerisque purus.",
      color: const Color.fromARGB(255, 219, 68, 57),
    ),
    Item(
      header: "Nivel 2",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis gravida eros, at luctus arcu luctus et. Integer cursus libero nec nulla cursus, et aliquet odio placerat. Nam vestibulum, nulla ut laoreet facilisis, ligula sem cursus libero, vel pulvinar nisi arcu nec sapien. Nullam tristique urna a erat venenatis, nec interdum risus bibendum. Curabitur in risus vitae lacus egestas fermentum. Phasellus at semper lorem. Integer in libero ut felis pharetra faucibus. Nunc volutpat lacus at ex posuere, a varius erat ultrices. Aenean elementum suscipit neque, non scelerisque purus.",
      color: const Color.fromARGB(255, 232, 108, 22),
    ),
    Item(
      header: "Nivel 3",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis gravida eros, at luctus arcu luctus et. Integer cursus libero nec nulla cursus, et aliquet odio placerat. Nam vestibulum, nulla ut laoreet facilisis, ligula sem cursus libero, vel pulvinar nisi arcu nec sapien. Nullam tristique urna a erat venenatis, nec interdum risus bibendum. Curabitur in risus vitae lacus egestas fermentum. Phasellus at semper lorem. Integer in libero ut felis pharetra faucibus. Nunc volutpat lacus at ex posuere, a varius erat ultrices. Aenean elementum suscipit neque, non scelerisque purus.",
      color: const Color.fromARGB(255, 245, 207, 64),
    ),
    Item(
      header: "Nivel 4",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis gravida eros, at luctus arcu luctus et. Integer cursus libero nec nulla cursus, et aliquet odio placerat. Nam vestibulum, nulla ut laoreet facilisis, ligula sem cursus libero, vel pulvinar nisi arcu nec sapien. Nullam tristique urna a erat venenatis, nec interdum risus bibendum. Curabitur in risus vitae lacus egestas fermentum. Phasellus at semper lorem. Integer in libero ut felis pharetra faucibus. Nunc volutpat lacus at ex posuere, a varius erat ultrices. Aenean elementum suscipit neque, non scelerisque purus.",
      color: const Color.fromARGB(255, 70, 168, 55),
    ),
    Item(
      header: "Nivel 5",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis gravida eros, at luctus arcu luctus et. Integer cursus libero nec nulla cursus, et aliquet odio placerat. Nam vestibulum, nulla ut laoreet facilisis, ligula sem cursus libero, vel pulvinar nisi arcu nec sapien. Nullam tristique urna a erat venenatis, nec interdum risus bibendum. Curabitur in risus vitae lacus egestas fermentum. Phasellus at semper lorem. Integer in libero ut felis pharetra faucibus. Nunc volutpat lacus at ex posuere, a varius erat ultrices. Aenean elementum suscipit neque, non scelerisque purus.",
      color: const Color.fromARGB(255, 34, 112, 158),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 53,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Image(
                  image: AssetImage('assets/alerta_unida_isotipo.png'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18, top: 15),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Niveles de emergencia y tiempo de espera',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  color: Color.fromARGB(255, 88, 88, 88),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color.fromARGB(255, 144, 144, 144),
            thickness: 5,
          ),
          const SizedBox(height: 20),
          ..._items.map((item) {
            return Card(
              color: item.color.withOpacity(1),
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ExpansionTile(
                backgroundColor: item.color.withOpacity(1),
                tilePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                title: Text(
                  item.header,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: item.color.withOpacity(0.1),
                    child: Text(
                      item.body,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ));
  }
}

class Item {
  Item({
    required this.header,
    required this.body,
    required this.color,
  });

  String header;
  String body;
  Color color;
}

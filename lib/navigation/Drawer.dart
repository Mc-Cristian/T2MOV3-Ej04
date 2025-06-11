import 'package:flutter/material.dart';
import 'package:t2_ejercicios04_drawer/main.dart';
import 'package:t2_ejercicios04_drawer/screens/AhorroCompuestoScreen.dart';
import 'package:t2_ejercicios04_drawer/screens/InteresSimpleScreen.dart';
import 'package:t2_ejercicios04_drawer/screens/PropinaScreen.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Menú de Ejercicios"),
                Expanded(
                  child: Container(), 
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text("Calculadora de Propinas"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PropinaScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text("Interés Simple"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InteresSimpleScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.savings),
            title: const Text("Ahorro Compuesto"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AhorroCompuestoScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Inicio"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Ejercicio2App()));
            },
          ),
        ],
      ),
    );
  }
}

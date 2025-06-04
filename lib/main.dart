import 'package:flutter/material.dart';
import 'package:t2_ejercicios04_drawer/screens/AhorroCompuestoScreen.dart';
import 'package:t2_ejercicios04_drawer/screens/InteresSimpleScreen.dart';
import 'package:t2_ejercicios04_drawer/screens/PropinaScreen.dart';


void main(){
  runApp(const Ejercicio2App());
}

class Ejercicio2App extends StatelessWidget {
  const Ejercicio2App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Cuerpo(),
      debugShowCheckedModeBanner: false, // Opcional: para quitar el banner de "Debug"
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ejercicios de Cálculo"), centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenido a los Ejercicios"),
            const SizedBox(height: 10),
            const Text("Selecciona una opción del menú lateral"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:[
            const DrawerHeader(
              child: Text("Menú Principal"),
            ),
            ListTile(
              title: const Text("Calculadora de Propinas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PropinaScreen()));
              },
            ),
            ListTile(
              title: const Text("Calculadora de Interés Simple"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const InteresSimpleScreen()));
              },
            ),
            ListTile(
              title: const Text("Simulador de Ahorro Compuesto"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AhorroCompuestoScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
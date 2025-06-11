//3.-Simulador de ahorro mensual
//Implementa una aplicación que calcule el ahorro acumulado con depósitos
//mensuales.
//Requisitos:
//• Campos para: Ahorro mensual, Cantidad de meses
//• Fórmula básica (sin interés): AhorroTotal = AhorroMensual × CantidadMeses
//• Mostrar el total ahorrado y el detalle mes por mes
//• Opcional: Agregar campo para tasa de interés mensual y modificar la fórmula
//• Validar que los valores ingresados sean números positivos

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:t2_ejercicios04_drawer/navigation/Drawer.dart';

class AhorroCompuestoScreen extends StatefulWidget {
  const AhorroCompuestoScreen({super.key});

  @override
  State<AhorroCompuestoScreen> createState() => _AhorroCompuestoScreenState();
}

class _AhorroCompuestoScreenState extends State<AhorroCompuestoScreen> {
  final TextEditingController _ahorroMensualController = TextEditingController();
  final TextEditingController _cantidadMesesController = TextEditingController();
  final TextEditingController _tasaInteresMensualController = TextEditingController(); 

  double _ahorroTotal = 0.0;
  List<Map<String, double>> _detalleAhorro = [];
  String _errorText = '';
  bool _calculoRealizado = false; // Bandera para controlar la visibilidad de los resultados

  void _simularAhorro() {
    setState(() {
      _errorText = ''; // Limpiar errores anteriores
      _calculoRealizado = false;
      _detalleAhorro = []; // Limpiar detalle anterior

      final double? ahorroMensual = double.tryParse(_ahorroMensualController.text);
      final int? cantidadMeses = int.tryParse(_cantidadMesesController.text);
      final double? tasaInteresMensual = double.tryParse(_tasaInteresMensualController.text);

      // Validaciones
      if (ahorroMensual == null || ahorroMensual <= 0) {
        _errorText = 'Ahorro mensual debe ser un número positivo.';
        _ahorroTotal = 0.0;
        return;
      }
      if (cantidadMeses == null || cantidadMeses <= 0) {
        _errorText = 'Cantidad de meses debe ser un número entero positivo.';
        _ahorroTotal = 0.0;
        return;
      }

      // Validar tasa de interés si se ingresó
      if (tasaInteresMensual != null && tasaInteresMensual < 0) {
        _errorText = 'La tasa de interés mensual no puede ser negativa.';
        _ahorroTotal = 0.0;
        return;
      }

      double tasaDecimal = 0.0;
      if (tasaInteresMensual != null) {
        tasaDecimal = tasaInteresMensual / 100.0; 
      }

      double acumulado = 0.0;
      for (int i = 1; i <= cantidadMeses; i++) {
        acumulado += ahorroMensual; 
        if (tasaDecimal > 0) {
          acumulado += (acumulado * tasaDecimal); 
        }
        _detalleAhorro.add({
          'mes': i.toDouble(),
          'ahorro_acumulado': acumulado,
        });
      }

      _ahorroTotal = acumulado;
      _calculoRealizado = true; 
    });
  }

  @override
  void dispose() {
    _ahorroMensualController.dispose();
    _cantidadMesesController.dispose();
    _tasaInteresMensualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulador de Ahorro Mensual"), centerTitle: true),
      drawer: const MiDrawer(), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo Ahorro Mensual
            const Text("Ahorro Mensual (\$):"),
            const SizedBox(height: 8),
            TextField(
              controller: _ahorroMensualController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Monto a ahorrar cada mes",
                hintText: "Ej: 50.00",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false; 
                });
              },
            ),
            const SizedBox(height: 15),

            // Campo Cantidad de Meses
            const Text("Cantidad de Meses:"),
            const SizedBox(height: 8),
            TextField(
              controller: _cantidadMesesController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Número de meses para ahorrar",
                hintText: "Ej: 12",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false;
                });
              },
            ),
            const SizedBox(height: 15),

            // Campo Opcional
            const Text("Tasa de Interés Mensual Opcional (%):"),
            const SizedBox(height: 8),
            TextField(
              controller: _tasaInteresMensualController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Interés mensual (ej. 0.5 para 0.5%)",
                hintText: "Ej: 0.5",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false; 
                });
              },
            ),
            const SizedBox(height: 20),

            // Mensaje de error
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Botón de acción 
            ElevatedButton( 
              onPressed: _simularAhorro,
              child: const Text("Simular Ahorro"),
            ),
            const SizedBox(height: 30),

            if (_calculoRealizado)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Resumen de Ahorro:"),
                  const SizedBox(height: 10),
                  Text("Ahorro Total Acumulado: \$${_ahorroTotal.toStringAsFixed(2)}"),
                  const SizedBox(height: 20),
                  const Text("Detalle Mes por Mes:"),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200, 
                    child: ListView.builder(
                      itemCount: _detalleAhorro.length,
                      itemBuilder: (context, index) {
                        final data = _detalleAhorro[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            "Mes ${data['mes']!.toInt()}: \$${data['ahorro_acumulado']!.toStringAsFixed(2)}",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

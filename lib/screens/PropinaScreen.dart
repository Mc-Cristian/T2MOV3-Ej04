import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t2_ejercicios04_drawer/navigation/Drawer.dart';


class PropinaScreen extends StatefulWidget {
  const PropinaScreen({super.key});

  @override
  State<PropinaScreen> createState() => _PropinaScreenState();
}

class _PropinaScreenState extends State<PropinaScreen> {
  final TextEditingController _montoController = TextEditingController();
  double _propinaPorcentaje = 0.15; // 15% por defecto
  double _montoPropina = 0.0;
  double _totalPagar = 0.0;
  String _errorText = '';
  bool _calculoRealizado = false; // para controlar la visibilidad de los resultados

  void _calcularPropina() {
    setState(() {
      _errorText = '';
      _calculoRealizado = false; 

      final String montoText = _montoController.text;
      if (montoText.isEmpty) {
        _errorText = 'Por favor, ingresa el monto.';
        _montoPropina = 0.0;
        _totalPagar = 0.0;
        return;
      }

      final double? monto = double.tryParse(montoText);
      if (monto == null || monto <= 0) {
        _errorText = 'Ingresa un monto numérico positivo.';
        _montoPropina = 0.0;
        _totalPagar = 0.0;
        return;
      }

      _montoPropina = monto * _propinaPorcentaje;
      _totalPagar = monto + _montoPropina;
      _calculoRealizado = true; 
    });
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de Propinas"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text("Monto Total de la Cuenta:"),
            const SizedBox(height: 10),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))], //un punto decimal opcional, y hasta dos decimales
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Monto:",
                hintText: "Ej: 100.00",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false;
                });
              },
            ),
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            const Text("Porcentaje de Propina:"),
            Slider(
              value: _propinaPorcentaje,
              min: 0.05, // 5% mínimo
              max: 0.50, // 50% máximo
              divisions: 25, // Para tener incrementos de 1%
              label: '${(_propinaPorcentaje * 100).round()}%',
              onChanged: (double newValue) {
                setState(() {
                  _propinaPorcentaje = newValue;
                  _calculoRealizado = false; 
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _propinaPorcentaje = 0.10;
                        _calculoRealizado = false;
                      });
                    },
                    child: const Text('10%'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _propinaPorcentaje = 0.15;
                        _calculoRealizado = false;
                      });
                    },
                    child: const Text('15%'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _propinaPorcentaje = 0.20;
                        _calculoRealizado = false;
                      });
                    },
                    child: const Text('20%'),
                  ),
                  // Muestra el porcentaje actual, incluyendo el "personalizado" del slider
                  Text('Actual: ${(_propinaPorcentaje * 100).round()}%'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularPropina,
              child: const Text("Calcular Propina"),
            ),
            const SizedBox(height: 30),
            if (_calculoRealizado)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Resultados:"),
                  const SizedBox(height: 10),
                  Text("Monto de la Propina: \$${_montoPropina.toStringAsFixed(2)}"),
                  const SizedBox(height: 5),
                  Text("Total a Pagar: \$${_totalPagar.toStringAsFixed(2)}"),
                ],
              ),
          ],
        ),
      ),
      drawer: const MiDrawer(),
    );
  }
}
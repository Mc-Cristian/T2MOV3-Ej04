import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t2_ejercicios04_drawer/navigation/Drawer.dart';


class InteresSimpleScreen extends StatefulWidget {
  const InteresSimpleScreen({super.key});

  @override
  State<InteresSimpleScreen> createState() => _InteresSimpleScreenState();
}

class _InteresSimpleScreenState extends State<InteresSimpleScreen> {
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();

  double _interesGenerado = 0.0;
  double _montoTotalFinal = 0.0;
  String _errorText = '';
  bool _calculoRealizado = false; // Bandera para controlar la visibilidad de los resultados

  void _calcularInteresSimple() {
    setState(() {
      _errorText = ''; // Limpiar errores anteriores
      _calculoRealizado = false; // Reiniciar la bandera antes de un nuevo cálculo

      final double? capital = double.tryParse(_capitalController.text);
      final double? tasa = double.tryParse(_tasaController.text);
      final double? tiempo = double.tryParse(_tiempoController.text);

      // Validaciones
      if (capital == null || capital <= 0) {
        _errorText = 'Capital inicial debe ser un número positivo.';
        _interesGenerado = 0.0;
        _montoTotalFinal = 0.0;
        return;
      }
      if (tasa == null || tasa <= 0) {
        _errorText = 'Tasa de interés anual debe ser un número positivo.';
        _interesGenerado = 0.0;
        _montoTotalFinal = 0.0;
        return;
      }
      if (tiempo == null || tiempo <= 0) {
        _errorText = 'Tiempo en años debe ser un número entero positivo.';
        _interesGenerado = 0.0;
        _montoTotalFinal = 0.0;
        return;
      }

      // Fórmula de interés simple: MontoFinal = CapitalInicial × (1 + (TasaInterés × Tiempo / 100))
      // Primero calculamos el interés generado: I = P * R * T
      final double tasaDecimal = tasa / 100.0; 
      _interesGenerado = capital * tasaDecimal * tiempo;

      // Luego el monto total final
      _montoTotalFinal = capital + _interesGenerado;
      
      _calculoRealizado = true; 
    });
  }

  void _limpiarCampos() {
    setState(() {
      _capitalController.clear();
      _tasaController.clear();
      _tiempoController.clear();
      _interesGenerado = 0.0;
      _montoTotalFinal = 0.0;
      _errorText = '';
      _calculoRealizado = false; 
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _tasaController.dispose();
    _tiempoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de Interés Simple"), centerTitle: true),
      drawer: const MiDrawer(), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text("Capital Inicial:"),
            const SizedBox(height: 8),
            TextField(
              controller: _capitalController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Monto del Capital",
                hintText: "Ej: 1000.00",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false; 
                });
              },
            ),
            const SizedBox(height: 15),

            // Campo Tasa de Interés Anual
            const Text("Tasa de Interés Anual (%):"),
            const SizedBox(height: 8),
            TextField(
              controller: _tasaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Porcentaje Anual",
                hintText: "Ej: 5.0",
              ),
              onChanged: (_) {
                setState(() {
                  _calculoRealizado = false; 
                });
              },
            ),
            const SizedBox(height: 15),

            // Campo Tiempo en Años
            const Text("Tiempo en Años:"),
            const SizedBox(height: 8),
            TextField(
              controller: _tiempoController,
              keyboardType: TextInputType.number,
              // Permite solo dígitos para años enteros
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Número de Años",
                hintText: "Ej: 3",
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

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calcularInteresSimple,
                    child: const Text("Calcular"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _limpiarCampos,
                    child: const Text("Limpiar"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Resultados (se muestran solo si _calculoRealizado es true)
            if (_calculoRealizado)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Desglose de Resultados:"),
                  const SizedBox(height: 10),
                  Text("Capital Inicial: \$${double.tryParse(_capitalController.text)?.toStringAsFixed(2) ?? '0.00'}"),
                  const SizedBox(height: 5),
                  Text("Interés Generado: \$${_interesGenerado.toStringAsFixed(2)}"),
                  const SizedBox(height: 5),
                  Text("Monto Total Final: \$${_montoTotalFinal.toStringAsFixed(2)}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
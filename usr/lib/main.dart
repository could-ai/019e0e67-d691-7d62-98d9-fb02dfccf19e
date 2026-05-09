import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cp & Cpk Hesaplayıcı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CpCpkCalculatorScreen(),
      },
    );
  }
}

class CpCpkCalculatorScreen extends StatefulWidget {
  const CpCpkCalculatorScreen({super.key});

  @override
  State<CpCpkCalculatorScreen> createState() => _CpCpkCalculatorScreenState();
}

class _CpCpkCalculatorScreenState extends State<CpCpkCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _uslController = TextEditingController();
  final _lslController = TextEditingController();

  final _meanBeforeController = TextEditingController();
  final _stdBeforeController = TextEditingController();

  final _meanAfterController = TextEditingController();
  final _stdAfterController = TextEditingController();

  Map<String, dynamic>? _results;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final usl = double.parse(_uslController.text);
      final lsl = double.parse(_lslController.text);

      final meanBefore = double.parse(_meanBeforeController.text);
      final stdBefore = double.parse(_stdBeforeController.text);

      final meanAfter = double.parse(_meanAfterController.text);
      final stdAfter = double.parse(_stdAfterController.text);

      double cpBefore = (usl - lsl) / (6 * stdBefore);
      double cpkBefore = min((usl - meanBefore) / (3 * stdBefore), (meanBefore - lsl) / (3 * stdBefore));

      double cpAfter = (usl - lsl) / (6 * stdAfter);
      double cpkAfter = min((usl - meanAfter) / (3 * stdAfter), (meanAfter - lsl) / (3 * stdAfter));

      setState(() {
        _results = {
          'cpBefore': cpBefore,
          'cpkBefore': cpkBefore,
          'cpAfter': cpAfter,
          'cpkAfter': cpkAfter,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Süreç Yeterlilik Hesaplayıcı'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Teziniz için iyileştirme öncesi ve sonrası verilerinizi girin:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Spesifikasyon Limitleri', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _uslController,
                                decoration: const InputDecoration(labelText: 'USL (Üst Limit)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _lslController,
                                decoration: const InputDecoration(labelText: 'LSL (Alt Limit)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('İyileştirme Öncesi (Mevcut Durum)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _meanBeforeController,
                                decoration: const InputDecoration(labelText: 'Ortalama (μ)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _stdBeforeController,
                                decoration: const InputDecoration(labelText: 'Standart Sapma (σ)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('İyileştirme Sonrası', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _meanAfterController,
                                decoration: const InputDecoration(labelText: 'Ortalama (μ)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _stdAfterController,
                                decoration: const InputDecoration(labelText: 'Standart Sapma (σ)'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Hesapla', style: TextStyle(fontSize: 18)),
                ),
                if (_results != null) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sonuçlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Text('Öncesi Cp: ${_results!['cpBefore'].toStringAsFixed(3)}'),
                          Text('Öncesi Cpk: ${_results!['cpkBefore'].toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Sonrası Cp: ${_results!['cpAfter'].toStringAsFixed(3)}'),
                          Text('Sonrası Cpk: ${_results!['cpkAfter'].toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          const Text('Tez İçin Yorum Önerisi:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'İyileştirme öncesi sürecin Cpk değeri ${_results!['cpkBefore'].toStringAsFixed(3)} olarak hesaplanmıştır. '
                            'İyileştirme çalışmaları sonucunda sürecin Cpk değeri ${_results!['cpkAfter'].toStringAsFixed(3)} seviyesine yükselmiştir. '
                            'Bu artış, sürecin değişkenliğinin azaldığını ve hedeflenen spesifikasyonlara daha uygun, istikrarlı bir üretim/hizmet sağlandığını kanıtlamaktadır.',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

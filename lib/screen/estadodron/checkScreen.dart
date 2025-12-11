import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/checklistProvider.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckListProvider(),
      child: const _CheckScreen(),
    );
  }
}

class _CheckScreen extends StatelessWidget {
  const _CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CheckListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Check de Implementos de ronda',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Revision de 4 brazos '),
              subtitle:
                  const Text('Se realizo la revision de los brazos del dron'),
              value: provider.brazonok,
              onChanged: (value) {
                provider.brazonok = value ?? false;
              },
            ),
            Divider(),
            CheckboxListTile(
              title: const Text('Revision de 4 helices '),
              subtitle:
                  const Text('Se realizo la revision de las helices del dron'),
              value: provider.helicesok,
              onChanged: (value) {
                provider.helicesok = value ?? false;
              },
            ),
            Divider(),
            CheckboxListTile(
              title: const Text('Revision de maleta '),
              subtitle:
                  const Text('Se realizo la revision de la maleta del dron'),
              value: provider.maletaok,
              onChanged: (value) {
                provider.maletaok = value ?? false;
              },
            ),
            Divider(),
            CheckboxListTile(
              title: const Text('Revision de gimbal '),
              subtitle:
                  const Text('Se realizo la revision del gimbal del dron'),
              value: provider.gimbalok,
              onChanged: (value) {
                provider.gimbalok = value ?? false;
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar fotos del dron / maleta'),
                onPressed: () async {
                  await provider.tomarFoto();
                },
              ),
            ),
            if (provider.fotos.isNotEmpty) ...[
              const Text(
                'Fotos tomadas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: provider.fotos.length,
                  controller: PageController(viewportFraction: 0.85),
                  itemBuilder: (context, index) {
                    final foto = provider.fotos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(foto.path),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${index + 1} / ${provider.fotos.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Aún no se han tomado fotos.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar check'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Resumen de check'),
                        content: Text(
                          provider.todoOk
                              ? 'Todas las revisiones del dron están completas.'
                              : 'Faltan revisiones por completar.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

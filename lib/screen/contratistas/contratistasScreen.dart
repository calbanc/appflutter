import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:rondines/provider/provider.dart';
import 'package:rondines/response/contratistaResponse.dart';

class ContratistasScreen extends StatefulWidget {
  const ContratistasScreen({super.key});

  @override
  State<ContratistasScreen> createState() => _ContratistasScreenState();
}

class _ContratistasScreenState extends State<ContratistasScreen> {
  bool encontrado = false;
  TextEditingController nommbrectrl = TextEditingController(text: '');
  TextEditingController rutconductorctrl = TextEditingController(text: '');
  TextEditingController patentectrl = TextEditingController(text: '');
  TextEditingController fechainicioctrl = TextEditingController(text: '');
  TextEditingController fechaterminoctrl = TextEditingController(text: '');
  TextEditingController observacionctrl = TextEditingController(text: '');
  TextEditingController rutcontratistactrl = TextEditingController(text: '');
  TextEditingController nombrecontratistactrl = TextEditingController(text: '');
  List<List<Data?>> rosw = [];
  String qr = '';
  int totaltrabajadores = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Registro de contratistas',
          style: TextStyle(color: Colors.white, fontFamily: 'PoppinsR'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Escanear qr',
                    labelText: 'Escanear qr',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        try {
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  '#3D8BEF', 'Cancelar', false, ScanMode.QR);
                          http.Response response = await controlAccesoProvider()
                              .getdatacontratista(barcodeScanRes);

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: ((context) {
                                return const Center(
                                  child: CupertinoAlertDialog(
                                    content: Row(
                                      children: [
                                        CupertinoActivityIndicator(),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('Consultando datos espere..'),
                                      ],
                                    ),
                                  ),
                                );
                              }));

                          if (response.statusCode == 200) {
                            Navigator.of(context).pop();
                            final responsecontratista =
                                contratistaResponseFromMap(response.body);
                            setState(() {
                              encontrado = true;
                              qr = barcodeScanRes;
                              nommbrectrl.text = responsecontratista
                                  .contratista![0].nombreConductor!;
                              rutconductorctrl.text =
                                  responsecontratista.contratista![0].rut!;
                              patentectrl.text =
                                  responsecontratista.contratista![0].patente!;
                              fechainicioctrl.text = responsecontratista
                                  .contratista![0].fechaInicio!;
                              fechaterminoctrl.text = responsecontratista
                                  .contratista![0].fechaTermino!;
                              rutcontratistactrl.text = responsecontratista
                                  .contratista![0].rutContratista!;
                              nombrecontratistactrl.text = responsecontratista
                                  .contratista![0].nombreContratista!;
                            });
                            final data = base64Decode(responsecontratista.xls!);
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final file =
                                File('${directory.path}/document.xlsx');
                            await file.writeAsBytes(data);
                            var file2 = file.path;
                            var bytes = File(file2).readAsBytesSync();
                            var excel = Excel.decodeBytes(bytes);

                            for (var table in excel.tables.keys) {
                              for (var row in excel.tables[table]!.rows) {
                                setState(() {
                                  rosw.add(row);
                                });
                              }
                            }
                            setState(() {
                              totaltrabajadores = rosw.length - 1;
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
                        } catch (e) {}
                      },
                      icon: const Icon(Icons.qr_code),
                    ),
                    border: const OutlineInputBorder()),
              ),
            ),
            encontrado
                ? Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: rutcontratistactrl,
                            decoration: const InputDecoration(
                                hintText: 'Rut Contratista',
                                labelText: 'Rut Contratista',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: nombrecontratistactrl,
                            decoration: const InputDecoration(
                                hintText: 'Nombre contratista',
                                labelText: 'Nombre contratista',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: rutconductorctrl,
                            decoration: const InputDecoration(
                                hintText: 'Rut Conductor',
                                labelText: 'Rut Conductor',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: nommbrectrl,
                            decoration: const InputDecoration(
                                hintText: 'Nombre Conductor',
                                labelText: 'Nombre Conductor',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: patentectrl,
                            decoration: const InputDecoration(
                                hintText: 'Patente',
                                labelText: 'Patente',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: fechainicioctrl,
                            decoration: const InputDecoration(
                                hintText: 'Fecha Inicio',
                                labelText: 'Fecha Inicio',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: fechaterminoctrl,
                            decoration: const InputDecoration(
                                hintText: 'Fecha Termino',
                                labelText: 'Fecha Termino',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: observacionctrl,
                            decoration: const InputDecoration(
                                hintText: 'Observacion',
                                labelText: 'Observacion',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Trabajadores',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(totaltrabajadores.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ListView.builder(
                              itemCount: rosw.length - 1,
                              itemBuilder: (context, index) {
                                String rut =
                                    rosw[index + 1][0]!.value.toString();
                                String nombre =
                                    rosw[index + 1][1]!.value.toString();
                                String apellidos =
                                    rosw[index + 1][2]!.value.toString();
                                String sexo =
                                    rosw[index + 1][3]!.value.toString();
                                String fecha =
                                    rosw[index + 1][4]!.value.toString();
                                String labor =
                                    rosw[index + 1][5]!.value.toString();

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text('Rut: $rut'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                  'Nombre y Apellido: $nombre $apellidos'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text('Sexo: $sexo'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text('Fecha: $fecha'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text('Labor: $labor'),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                rosw.remove(rosw[index]);
                                                totaltrabajadores = -1;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                );

                                //return Text(value);
                              }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: MaterialButton(
                              color: Colors.green,
                              onPressed: () async {
                                for (var i = 0; i <= rosw.length - 1; i++) {
                                  String rut = rosw[i + 1][0]!.value.toString();
                                  String nombre =
                                      rosw[i + 1][1]!.value.toString();
                                  String fecha_nacimiento =
                                      rosw[i + 1][2]!.value.toString();
                                  String sexo =
                                      rosw[i + 1][3]!.value.toString();
                                  String labor =
                                      rosw[i + 1][5]!.value.toString();

                                  TrabajadorContratista trabajador =
                                      TrabajadorContratista(
                                          idContratista: int.parse(qr),
                                          nombre: nombre,
                                          rut: rut,
                                          sexo: sexo,
                                          labor: labor);
                                  http.Response response =
                                      await controlAccesoProvider()
                                          .saveaccesocontratista(trabajador);
                                  if (response.statusCode != 200) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Error enviando registro de acceso');
                                  }

                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                'REGISTRAR INGRESO',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

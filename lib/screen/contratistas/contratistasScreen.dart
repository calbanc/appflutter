import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_excel/excel.dart';


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
  bool encontrado=false;
  TextEditingController nommbrectrl = TextEditingController(text: '');
  TextEditingController rutconductorctrl = TextEditingController(text: '');
  TextEditingController patentectrl = TextEditingController(text: '');
  TextEditingController fechainicioctrl = TextEditingController(text: '');
  TextEditingController fechaterminoctrl = TextEditingController(text: '');
  List<List<Data?>>rosw=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de contratistas'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Escanear qr',
                  labelText: 'Escanear qr',
                  suffixIcon: IconButton(onPressed: ()async {

                    try{
                      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
                      http.Response response=await controlAccesoProvider().getdatacontratista(barcodeScanRes);

                      if(response.statusCode==200){
                        final responsecontratista=contratistaResponseFromMap(response.body);
                        setState(() {
                          encontrado=true;
                            nommbrectrl.text=responsecontratista.contratista![0].nombreConductor!;
                            rutconductorctrl.text=responsecontratista.contratista![0].rut!;
                            patentectrl.text=responsecontratista.contratista![0].patente!;
                            fechainicioctrl.text=responsecontratista.contratista![0].fechaInicio!;
                            fechaterminoctrl.text=responsecontratista.contratista![0].fechaTermino!;
                        });
                        final data=base64Decode(responsecontratista.xls!);
                        final directory = await getApplicationDocumentsDirectory();
                        final file = File('${directory.path}/document.xlsx');
                        await file.writeAsBytes(data);
                        var file2 = file.path;
                        var bytes = File(file2).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        for (var table in excel.tables.keys) {

                          for (var row in excel.tables[table]!.rows) {
                            setState(() {
                              rosw.add(row );
                            });
                          }
                        }

                      }



                    }catch(e){
                    }


                  },icon: Icon(Icons.qr_code),),
                  border: OutlineInputBorder(

                  )


                ),
              ),
            ),

           encontrado ? Container(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: rutconductorctrl,
                      decoration:const InputDecoration(
                          hintText: 'Rut Conductor',
                          labelText: 'Rut Conductor',
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: nommbrectrl,
                      decoration:const InputDecoration(
                          hintText: 'Nombre Conductor',
                          labelText: 'Nombre Conductor',
                          border: OutlineInputBorder(

                          )


                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: patentectrl,
                      decoration:const InputDecoration(
                          hintText: 'Patente',
                          labelText: 'Patente',
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: fechainicioctrl,
                      decoration:const InputDecoration(
                          hintText: 'Fecha Inicio',
                          labelText: 'Fecha Inicio',
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: fechaterminoctrl,
                      decoration:const InputDecoration(
                          hintText: 'Fecha Termino',
                          labelText: 'Fecha Termino',
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: ListView.builder(
                        itemCount: rosw.length,
                        itemBuilder: (context,index){

                          String rut=rosw[index][0]!.value;
                          String nombre=rosw[index][1]!.value;
                          String apellidos=rosw[index][2]!.value;
                          String sexo=rosw[index][3]!.value;
                          String fecha=rosw[index][4]!.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Text('Rut: $rut'),
                                  Text('Nombre y Apellido: $nombre $apellidos'),
                                  Text('Sexo: $sexo'),
                                  Text('Fecha: $fecha'),
                                ],
                              ),
                            ),
                          );

                          //return Text(value);
                        }

                    ),
                  )

                ],
              ),

            ):Container()



          ],
        ),
      ),
    );
  }
}

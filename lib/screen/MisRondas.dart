
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


import 'package:intl/intl.dart';

import '../provider/RondaProvider.dart';
import '../response/reportClientResponse.dart';
import '../ui/input_decorations.dart';

class MisRondas extends StatelessWidget {
  RondaProvider provider;
  MisRondas({super.key,required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Mis Rondas',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
              child: TextFormField(
                controller: provider.fechaController,
                autocorrect: false,
                style: TextStyle(fontSize: 14,fontFamily: 'PoppinsR'),
                decoration: InputDecorations.authInputDecoration(
                  hintext: 'Fecha',
                  labeltext: 'Fecha',
                ),
                onTap: () async {
                  provider.fechaController.text = "";
                  DateTime dateTime = new DateTime.now();
                  var nuevafecha =
                  DateTime(dateTime.year, dateTime.month - 1, 1);
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? datepicker = await showDatePicker(
                      confirmText: 'Ok',
                      cancelText: 'Cancelar',
                      helpText: 'Seleccione fecha',
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: nuevafecha,
                      lastDate: DateTime(2100));
                  if (datepicker != null) {
                    provider.fechaController.text =
                        DateFormat('yyyy-MM-dd').format(datepicker);
                  }
                },
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Debe ingresar una facha valido'
                      : null;
                },
              ),
            ),
        
            SizedBox(width: MediaQuery.of(context).size.width,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(36, 99, 174, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  onPressed: ()async{
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: ((context) {
                          return const Center(
                            child: AlertDialog(
                              content: Row(
                                children: [
                                  CupertinoActivityIndicator(),
                                  Text('Consultando datos'),
                                ],
                              ),
                            ),
                          );
                        }));
                    http.Response respuesta=await provider.getguardsbyuser(provider.fechaController.text);
                    Navigator.of(context).pop();
                    if(respuesta.statusCode==200){
                      final response=ReportClientResponse.fromJson(respuesta.body);
                      provider.listareport=response.data!;
                    }
                  },
                  child: Text('Consultar',style: TextStyle(color: Colors.white,fontFamily: 'PoppinsB'),),
                ),
              ),),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: ListView.builder(
                itemCount: provider.listareport.length,
                itemBuilder: (context,index){
                  String puntocontrol=provider.listareport[index].puntocontrol!;
                  String observacion=provider.listareport[index].observation!;
                  String zona=provider.listareport[index].zona!;
                  String hora=provider.listareport[index].time!;
                  String idimagen=provider.listareport[index].idimage!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 0.5,
                              color: Colors.grey
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 80,
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(70)),
                                child:CachedNetworkImage(
                                  imageUrl:'https://cliente.seguridadsegser.com/assets/rondas/$idimagen.png' ,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(puntocontrol,style: TextStyle(fontFamily: 'PoppinsB'),),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: Text(observacion,maxLines: 20,style: TextStyle(fontFamily: 'PoppinsL'),)),
                              Text(zona,style: TextStyle(fontFamily: 'PoppinsL'),),
                              Text(hora,style: TextStyle(fontFamily: 'PoppinsL'),),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
        
                }
            ))
        
          ],
        ),
      ),
    );
  }
}
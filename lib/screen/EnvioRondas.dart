import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rondines/provider/db_provider.dart';
import 'package:rondines/response/guardResponse.dart';
import 'package:http/http.dart' as http;
import '../provider/RondaProvider.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
class EnvioRondas extends StatelessWidget {
  RondaProvider provider;
  EnvioRondas({super.key,required this.provider});

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> _children = {
      0: Text('No Enviados',style: TextStyle(fontFamily: 'PoppinsR'),),
      1: Text('Enviados',style: TextStyle(fontFamily: 'PoppinsR'),),

    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Enviar Rondas',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MaterialSegmentedControl(
              children: _children,
              selectionIndex: provider.currentindexsegment,
              borderColor: Colors.blueAccent,
              selectedColor: Colors.blueAccent,
              unselectedColor: Colors.white,
              selectedTextStyle: TextStyle(color: Colors.white),
              unselectedTextStyle: TextStyle(color: Colors.black),
              borderWidth: 0.7,
              borderRadius: 32.0,
              disabledChildren: [3],
              onSegmentTapped: (index) {
              provider.currentindexsegment=index;
              },
            ),
          ),


            provider.currentindexsegment==0 ?  SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: ListView.builder(
                itemCount: provider.listaguards.length,
                itemBuilder: (context,index){
                  String path=provider.listaguards[index].idimage!;
                  String observacion=provider.listaguards[index].observacion!;
                  String punto=provider.listaguards[index].punto!;
                  String fecha=provider.listaguards[index].date!+" "+provider.listaguards[index].time!;
                  String namefoto =
                      provider.listaguards[index].date!.replaceAll("-", "") +
                          provider.listaguards[index].time!.replaceAll(":", "");
                  int id=provider.listaguards[index].id!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.black26
                        )
                      ),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 100,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1160),
                                      child: Image.file(File(path))),),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Punto:$punto',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'PoppinsR'),),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text('Observacion:$observacion',maxLines: 20,style: TextStyle(fontFamily: 'PoppinsL'),)),
                                  Text('Fecha:$fecha',style: TextStyle(fontSize: 15,fontFamily: 'PoppinsL'),),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(onPressed: ()async{
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Eliminar registro de ronda',style: TextStyle(fontFamily: 'PoppinsB'),),
                                          content: const Text(
                                              'Desea eliminar registro de ronda',style: TextStyle(fontFamily: 'PoppinsL')
                                          ),
                                          actions: <Widget>[
                                            Column(
                                              children: [
                                                SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(  style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                                  ),
                                                ),onPressed: ()async{
                                                  await DBProvider.db.deleteronda(id);
                                                  provider.getguardsavailable();
                                                  Navigator.of(context).pop();

                                                },child: Text('Eliminar',style: TextStyle(fontFamily: 'PoppinsB',color: Colors.white),),),),
                                                SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(  style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromRGBO(36, 99, 174, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                                  ),
                                                ),onPressed: (){
                                                  Navigator.of(context).pop();
                                                },child: Text('Cancelar',style: TextStyle(fontFamily: 'PoppinsB',color: Colors.white)),),)
                                              ],
                                            )

                                          ],
                                        );
                                      },
                                    );
                                  }, icon: Icon(Icons.cancel_outlined,color: Colors.red,)),
                                  IconButton(onPressed: ()async{

                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Actualizar registro de ronda',style: TextStyle(fontFamily: 'PoppinsB'),),
                                          content:  Column(children: [
                                            const Text('Desea actualizar registro de ronda',style: TextStyle(fontFamily: 'PoppinsL')),
                                            TextFormField(
                                              controller: provider.observacioneditController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(9)),
                                                labelText: 'Observacion',
                                              ),)
                                          ]

                                          ),
                                          actions: <Widget>[
                                            Column(
                                              children: [
                                                SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(  style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                                  ),
                                                ),onPressed: ()async{
                                                  if(provider.observacioneditController.text.isNotEmpty){
                                                    DBProvider.db.udpatecomentario(id, provider.observacioneditController.text);
                                                    provider.getguardsavailable();
                                                  }
                                                  Navigator.of(context).pop();

                                                },child: Text('Actualizar',style: TextStyle(fontFamily: 'PoppinsB',color: Colors.white),),),),
                                                SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(  style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromRGBO(36, 99, 174, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12), // <-- Radius
                                                  ),
                                                ),onPressed: (){
                                                  Navigator.of(context).pop();
                                                },child: Text('Cancelar',style: TextStyle(fontFamily: 'PoppinsB',color: Colors.white)),),)
                                              ],
                                            )

                                          ],
                                        );
                                      },
                                    );

                                  }, icon: Icon(Icons.edit_outlined,color: Colors.blueAccent,))
                                ],
                              )

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                color: Colors.green,
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
                                                Text('Enviando Registro'),
                                              ],
                                            ),
                                          ),
                                        );
                                      }));
                                  http.Response respuesta = await RondaProvider().uploadImage(path!, namefoto);
                                  http.Response respuesta2 = await RondaProvider().sync(provider.listaguards[index]);
                                  if (respuesta2.statusCode == 200) {
                                    Navigator.of(context).pop();
                                    final res = await DBProvider.db.updatesync(provider.listaguards[index].id!);
                                    await provider.getguardsavailable();
                                    await provider.getguardsends();
                                    provider.currentindexsegment=1;
                                  }else{
                                    Navigator.of(context).pop();

                                  }
                                },
                                child: const Text('ENVIAR REGISTRO',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),

                        ]

                      ),
                    ),
                  );
                },
              ),
            ):SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: ListView.builder(
                itemCount: provider.listaguardsends.length,
                itemBuilder: (context,index){
                  String path=provider.listaguardsends[index].idimage!;
                  String observacion=provider.listaguardsends[index].observacion!;
                  String punto=provider.listaguardsends[index].punto!;
                  String fecha=provider.listaguardsends[index].date!+" "+provider.listaguardsends[index].time!;

                  int id=provider.listaguardsends[index].id!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1.5,
                              color: Colors.green
                          )
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 100,
                              width: 50,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1160),
                                  child: Image.file(File(path))),),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Punto:$punto',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'PoppinsR'),),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: Text('Observacion:$observacion',maxLines: 20,style: TextStyle(fontFamily: 'PoppinsL'),)),
                              Text('Fecha:$fecha',style: TextStyle(fontSize: 15,fontFamily: 'PoppinsL'),),
                            ],
                          ),


                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            provider.currentindexsegment==0 ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(36, 99, 174, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),onPressed:provider.isloading? null: ()async{
                  List<Guard>listadisponibles=await DBProvider.db.getguarddisponible();

                  bool conectado = await InternetConnection().hasInternetAccess;
                  if(conectado){
                    try{
                      provider.isloading=true;
                      listadisponibles.forEach((element) async {
                        String nombrefoto =
                            element.date!.replaceAll("-", "") +
                                element.time!.replaceAll(":", "");
                        http.Response respuesta = await RondaProvider().uploadImage(element.idimage!, nombrefoto);
                        http.Response respuesta2 = await RondaProvider().sync(element);
                        if (respuesta2.statusCode == 200) {
                          final res = await DBProvider.db.updatesync(element.id!);
                        }
                      });
                      Fluttertoast.showToast(msg: 'Datos enviados correctamente',toastLength: Toast.LENGTH_SHORT);
                      await provider.getguardsavailable();
                      await provider.getguardsends();
                      provider.currentindexsegment=1;
                      provider.isloading=false;
                    }catch(e){
                      provider.isloading=false;
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: ((context) {
                            return  Center(
                              child: CupertinoAlertDialog(
                                content: Row(
                                  children: [
                                    Text('Error enviando datos $e'),
                                  ],
                                ),
                              ),
                            );
                          }));
                    }

                  }else{
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: ((context) {
                          return const Center(
                            child: CupertinoAlertDialog(
                              content: Row(
                                children: [
                                  Text(
                                      'Sin conexion para enviar datos'),
                                ],
                              ),
                            ),
                          );
                        }));
                  }
                },child:provider.isloading ? CupertinoActivityIndicator() :  Text('ENVIAR DATOS',style: TextStyle(fontFamily: 'PoppinsB',color: Colors.white)),),
              ),
            ) : Container()

          ],
        ),
      ),
    );
  }
}
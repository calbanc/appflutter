import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/ui/general.dart';
import '../provider/db_provider.dart';
import '../response/guardResponse.dart';

class Ronda_screen extends StatelessWidget {
  const Ronda_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>RondaProvider(),
      child: _Ronda_screen(),
      );
  }
}


class _Ronda_screen extends StatelessWidget {
  const _Ronda_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<RondaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Genera tu ronda'),
        centerTitle: true,

      ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center( 
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: (){
                      String tipo='INICIO';
                      Navigator.pushNamed(context, 'scan' ,arguments: {"tipo":tipo});
                    },
                    child:Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 140,
                      padding:const EdgeInsets.all(18),
                      
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(120))
                      ),
                      child: const Center(child: Text('INICIAR RONDA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)) 
                          
                
                    ) 
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: (){
                       String tipo='CONTROL';
                      Navigator.pushNamed(context, 'scan' ,arguments: {"tipo":tipo});
                   
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 140,
                    padding: EdgeInsets.all(18),
                    
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(120))
                    ),
                    child: Center(child: Text('SOLO CONTROL',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
          
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: (){
                       String tipo='TERMINO';
                      Navigator.pushNamed(context, 'scan' ,arguments: {"tipo":tipo});
                   
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 140,
                    padding: EdgeInsets.all(18),
                    
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(120))
                    ),
                    child:const Center(child: Text('FINALIZAR RONDA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
          
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: FutureBuilder(
                      future: DBProvider.db.getguarddisponible(),
                      builder: (BuildContext context,AsyncSnapshot<List<Guard>> snapshot){
                        if(snapshot.hasData){
                            List<Guard>listadisponible=snapshot.data!;
                           if (listadisponible.length>0){
                             Future.microtask(() async {
                              bool isonline=await general().isOnlineNet();
                              if(isonline){
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return CupertinoAlertDialog(
                                        content: Column(
                                          children: const [
                                            CupertinoActivityIndicator(),
                                            Text('ENVIANDO DATOS '),
                                          ],
                                        ),
                                      );
                                    }));
                                listadisponible.forEach((element) async {
                                  String nombrefoto =
                                      element.date!.replaceAll("-", "") +
                                          element.time!.replaceAll(":", "");

                                  http.Response respuesta = await RondaProvider().uploadImage(element.idimage!, nombrefoto);
                                  http.Response respuesta2 = await RondaProvider().sync(element);
                                  if (respuesta2.statusCode == 200) {
                                    final res = await DBProvider.db.updatesync(element.id!);
                                  }
                                  Navigator.of(context, rootNavigator: true).pop();
                                });

                                }else{
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return CupertinoAlertDialog(
                                        content: Column(
                                          children: const [

                                            Text('SIN CONEXION NO OLVIDE ENVIAR DATOS '),
                                          ],
                                        ),
                                      );
                                    }));
                              }

                             });

                             return  Container();


                      }else{
                             return Container();
                           }




                        }else{
                          return Container();
                        }
                      }
                  ),
              )
            ],
          ),
        ),

   
    );
  }
}


class ScanScreen extends StatelessWidget {
  
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    
    String tipo=arguments['tipo'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          
          child: Image.asset('assets/readernfc.gif')),

        FutureBuilder(
          future: NfcManager.instance.isAvailable(),
          builder: (BuildContext context,AsyncSnapshot<bool> snapshot)  {
            if(!snapshot.hasData){
              return CupertinoActivityIndicator();
            }else{
              bool respuesta=snapshot.data!;
              if(respuesta){
                 NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                    print(tag);
                    Uint8List identifier= Uint8List.fromList(tag.data["nfca"]['identifier']);

                        String nfc=HEX.encode(identifier);
                          
                        Navigator.pushReplacementNamed(context, 'registra', arguments: {"nfc":nfc.
                        toUpperCase(),"tipo":tipo});
        
        
                        });

                

                return Container();
              }else{
                QuickAlert.show(
                  context: context, 
                  type: QuickAlertType.warning,
                  title: 'Sin Nfc',
                  text: 'Su telefono no cuenta con compatibilidad NFC'
                );
                return Container();
        
              }
        
            }
          }),
      ],
    );
    
  }
}

import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hex/hex.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/db_provider.dart';
import '../response/getdatacode_Response.dart';
import '../response/gettypeguardsbycompany_Response.dart';
import 'EnvioRondas.dart';
import 'MisRondas.dart';

class Ronda_screen extends StatelessWidget {
  const Ronda_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>RondaProvider(),
      child: MainRondaScreen(),
      );
  }
}

class MainRondaScreen extends StatelessWidget {
  const MainRondaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<RondaProvider>(context);
    late List<Widget> _pages=[EnvioRondas(provider:provider),_Ronda_screen(),MisRondas(provider:provider)];

    return Scaffold(
      body: _pages[provider.currentindex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => {
              provider.currentindex=index
          },
          selectedItemColor: Colors.blue,
          selectedFontSize: 14,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.visible),
          currentIndex: provider.currentindex,
          items: const [
            BottomNavigationBarItem(
                label: 'Envio Rondas',
                icon: Icon(Icons.upload)
            ),
            BottomNavigationBarItem(
                label: 'Nueva Ronda',
                icon: Icon(Icons.add_circle_outline)
            ),
            BottomNavigationBarItem(
                label: 'Mis Rondas',
                icon: Icon(Icons.dashboard)
            ),


          ],
        )
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
        title:const Text('Genera tu ronda',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: ()async{

            bool conectado = await InternetConnection().hasInternetAccess;
            if(conectado){
              try{
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
                              Text(
                                  'Sincronizando datos espere..'),
                            ],
                          ),
                        ),
                      );
                    }));

                final http.Response respuestapoint=await provider.getpoints();
                if(respuestapoint.statusCode==200){
                  final points=GetdatacodeResponse.fromJson(respuestapoint.body);
                  List<Point>listapoints=points.point!;
                  listapoints.forEach((element) async=> {
                    await DBProvider.db.insertpoint(element)
                  });

                }
                final http.Response respuestatypeguard=await provider.gettypeguard();
                if(respuestatypeguard.statusCode==200){
                  final tipoguardia=GettypeguardsbycompanyResponse.fromJson(respuestatypeguard.body);
                  List<TipoGuard>listatipo=tipoguardia.tipoguard!;
                  listatipo.forEach((element) async =>{
                    await DBProvider.db.inserttypeguard(element)
                  });
                }
                Navigator.of(context).pop();
              }catch(e){
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: ((context) {
                      return const Center(
                        child: CupertinoAlertDialog(
                          content: Row(
                            children: [


                              Text(
                                  'Error descagando datos'),
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
                                'Sin conexion para descargar datos'),
                          ],
                        ),
                      ),
                    );
                  }));
            }








          }, icon: Icon(Icons.sync,color: Colors.white,))
        ],
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
                        borderRadius: BorderRadius.all(Radius.circular(20))
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
                      borderRadius: BorderRadius.all(Radius.circular(20))
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
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child:const Center(child: Text('FINALIZAR RONDA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
          
                  ),
                ),
              ),

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
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Listo para Escanear',style: TextStyle(fontSize: 20,color: Colors.black54),),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.width*0.5,

              child: Image.asset('assets/nfcreader.gif')),
          ),
          const Text('Acerca tu telefono a la etiqueta nfc',style: TextStyle(fontSize: 20,color: Colors.black54),),
      
          FutureBuilder(
            future: NfcManager.instance.isAvailable(),
            builder: (BuildContext context,AsyncSnapshot<bool> snapshot)  {
              if(!snapshot.hasData){
                return CupertinoActivityIndicator();
              }else{
                bool respuesta=snapshot.data!;
                if(respuesta){
                   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
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
      ),
    );
    
  }
}

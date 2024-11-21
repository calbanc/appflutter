import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/db_provider.dart';
import 'package:rondines/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rondines/ui/general.dart';
class RegistrControl extends StatelessWidget {
  const RegistrControl({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    String nfc=arguments['nfc'];
    String tipo=arguments['tipo'];


    return ChangeNotifierProvider(
      create: (_)=>RondaProvider(),
      child: RegistraControl(nfc:nfc,tipo:tipo),
      );
  }
}



class RegistraControl extends StatelessWidget {
    final nfc;
    final tipo;

  const RegistraControl({super.key,required this.nfc,required this.tipo});

  @override
  Widget build(BuildContext context) {
    
  final provider=Provider.of<RondaProvider>(context);
  final picker = new ImagePicker();
  

   void _showActionSheet(context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Opciones'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.

            onPressed: () async {
              final PickedFile? pickedFile = await picker.getImage(
                  source: ImageSource.camera, imageQuality: 100);
                if (pickedFile != null) {
                  provider.imagepath = pickedFile.path;
                }  
              
              Navigator.pop(context);
            },
            child: const Text(
              'Tomar Foto',
              style: TextStyle(fontSize: 12),
            ),
          ),
    
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  } 
  
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          provider.position=position;
    }).catchError((e) {
      debugPrint(e);
    });
  }
    return Scaffold(
      appBar: AppBar(
        title:const Text('Registra Ronda'),
        centerTitle: true,
      ),
      body: Form(
        key: provider.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: [
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: CupertinoButton(
                  color: Colors.blue,
                  child: Text('Tomar foto'),
                  onPressed: ()=>_showActionSheet(context)
                ),
                
              ), 
          
              const SizedBox(height: 10,),
          
              provider.imagepath=='' ? Center():Center(
                          child: Image.file(
                            File(provider.imagepath),
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.4,
                          ),
                ),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 4),
                child: Center(
                  child: FutureBuilder(
                    future: DBProvider.db.getpointbycode(nfc),
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if(!snapshot.hasData){
                        return const  CupertinoActivityIndicator();
                      }else{
                        List<Point>datos=snapshot.data!;

                          if(datos.length>0){
                            provider.idclient=datos[0].idclient!;
                          provider.idzona=datos[0].idzone!;
                          provider.idpoint=datos[0].id!;
          
                          return TextFormField(
                            initialValue: datos[0].name!,
                            decoration: InputDecoration(
                              labelText: 'Punto de Control',
                              // Set border for enabled state (default)
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              // Set border for focused state
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 3, color: Colors.red),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        );
                          }else{
                               Future.microtask(() => {
                            QuickAlert.show(
                            context: context, 
                            type: QuickAlertType.error,
                            title: 'Tag NFC no encontrado',

                          )

                          });
                          }


                          
                        
          
          

                        
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18,),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 4),
                child: Center(
                  child: FutureBuilder(
                    future: DBProvider.db.gettypeguard(),
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      
                      if(!snapshot.hasData){
                        return const Text('Cargando tipos de guardia ...');
                      }else{
                        List<TipoGuard>lista=snapshot.data;
                          return DropdownSearch<TipoGuard>(
                          validator: (value)  {
                            return (value == null)
                                  ? 'Debe seleccionar un tipo de guardia'
                                  : null;
                          },
                          popupProps: const PopupProps.dialog(
                              title: Text('Seleccione tipo de guardia'),
                              showSearchBox: true,
                              isFilterOnline: true),
                          items: lista!,
                          itemAsString: (TipoGuard u) =>
                                              u.name!,
                          
                          dropdownDecoratorProps:  DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                     borderRadius: BorderRadius.circular(15),
                                    ),
                                labelText: "Seleccione tipo de guardia"),
                          ),
                          onChanged: (TipoGuard? value) {
                            provider.idtipoguard=value!.id;
                             
                          },
                          
                        
                        );

                        
                      }
                  
                    }
                  ),
                ),
              ),
          
               ListTile(
                      title: const Text('Si cumple'),
                      leading: Radio<String>(
                        value: 'Si',
                        groupValue: provider.cumple,
                        onChanged: (String? value) {
                          provider.cumple='Si';
                        },
                      ),
                    ),
              ListTile(
                      title: const Text('No cumple'),
                      leading: Radio<String>(
                        value: 'No',
                        groupValue: provider.cumple,
                        onChanged: (String? value) {
                          provider.cumple='No';
                        },
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 4),
                child: TextFormField(
                  validator: (value)  {
                       return (value == '' || value!.isEmpty )
                                  ? 'Debe ingresar una observacion'
                                  : null;
                  },
                  onChanged: (value){
                    provider.Observacion=value;
                  },
                   decoration: InputDecoration(
                    errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    
                    labelText: 'Observacion ',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                          ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: CupertinoButton(
                  
                  borderRadius: BorderRadius.circular(36),
                  color: Colors.green,
                  child: provider.isloading ? CupertinoActivityIndicator() : Text('Guardar'),
                  onPressed: ()async {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if(!provider.isValidateForm() || provider.imagepath==''){
                      
                      QuickAlert.show(context: context, 
                      type: QuickAlertType.warning,
                      title: 'Faltan datos',
                      text:'Estimado usuario valide datos, e imagen'

                      );
                      return;
                    };

                    bool conectado=await general().isOnlineNet();

                    if(conectado){
                       showDialog(context: context, builder: ((context) {
                      return  CupertinoAlertDialog(
                        content: Column(children: const [
                          CupertinoActivityIndicator(),
                          Text('Registrando imagen'),
                        ],),
                      );
                    }));

                    provider.isloading=true;
                    await _getCurrentPosition();
                    provider.tipo=tipo;

                    String fecha=DateFormat('dd/MM/yyyy').format(DateTime.now());
                    String hora=DateFormat('HH:mm:ss').format(DateTime.now());
                    String nombrefoto=fecha.replaceAll("/", "")+hora.replaceAll(":", "");
                    provider.imagename=nombrefoto;
                    http.Response respuesta=await provider.uploadImage(provider.imagepath, nombrefoto);
                    if(respuesta.statusCode==200){
                      Navigator.of(context, rootNavigator: true).pop();

                      //enviamos los datos
                       showDialog(context: context, builder: ((context) {
                      return  CupertinoAlertDialog(
                        content: Column(children: const [
                          CupertinoActivityIndicator(),
                          Text('Registrando datos'),
                        ],),
                      );
                    }));
                      http.Response respuestadatos=await provider.save(provider);
                      if(respuestadatos.statusCode==200){


                        provider.isloading=false;
                        provider.imagepath='';
                        Navigator.of(context, rootNavigator: true).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Datos registrados correctamente',style: TextStyle(color: Colors.white),),
                            backgroundColor: Colors.green,
                            ),
                    );
                        Navigator.pushReplacementNamed(context, 'ronda');

                      }else{
                        provider.isloading=false;
                         QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error ',
                        text: 'Error enviando datos'
                      );
                      }





                    }else{
                      provider.isloading=false;
                       QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error ',
                        text: 'Error enviando imagen'
                      );
                    }
                    }else{
                      await _getCurrentPosition();
                      final iduser=await general().getiduserfromtoken();
                      String date=DateFormat('yyyy-MM-dd').format(DateTime.now());
                      String time=DateFormat('HH:mm:ss').format(DateTime.now());
                      Guard guardia= Guard(
                        iduser: iduser,
                        idtypeguar: provider.idtipoguard,
                        date:date,
                        time: time,
                        lat:provider.position.latitude.toString(),
                        longi: provider.position.longitude.toString(),
                        idpoint: provider.idpoint,
                        observacion: provider.Observacion,
                        isok: provider.cumple=='Si' ? '1' : '0',
                        idimage: provider.imagepath,
                        typepoint: tipo,
                        sw_enviado: "0"
                      );
                        print(guardia);
                        final res=await DBProvider.db.insertguard(guardia);
                        print(res);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos registrados correctamente localmente ',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, 'ronda');



                    }


                    







                  },
                ),
              )
              
          
              
            
              
              
          ],
          ),
        )
      ),
    );
  }
}
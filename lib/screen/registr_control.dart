import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
import 'package:share_plus/share_plus.dart';
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
        backgroundColor: Colors.blueAccent,
        title:const Text('Registra Ronda',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: provider.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
               /*Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: CupertinoButton(
                  color: Colors.blue,
                  child: Text('Tomar foto'),
                  onPressed: ()=>_showActionSheet(context)
                ),
                
              ),*/
          

          
              provider.imagepath=='' ? GestureDetector(
                onTap: ()=>_showActionSheet(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Click para tomar foto',style: TextStyle(fontSize: 20),),
                        Icon(Icons.camera_enhance_outlined,size: 80,),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent)

                    ),
                  ),
                ),
              ):Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.file(
                              File(provider.imagepath),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.4,
                            ),
                          ),
                ),
              const SizedBox(height: 10,),
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
                            Fluttertoast.showToast(msg: 'Tarjeta NFC no registrada');
                            Navigator.of(context).pop();

                             /*  Future.microtask(() => {
                            QuickAlert.show(
                            context: context, 
                            type: QuickAlertType.error,
                            title: 'Tag NFC no encontrado',

                          )

                          });*/
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
                  controller: provider.observacionController,
                  validator: (value)  {
                       return (value == '' || value!.isEmpty )
                                  ? 'Debe ingresar una observacion'
                                  : null;
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
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


                        await _getCurrentPosition();
                        final iduser=await general().getiduserfromtoken();
                        String date=DateFormat('yyyy-MM-dd').format(DateTime.now());
                        String time=DateFormat('HH:mm:ss').format(DateTime.now());
                        provider.Observacion=provider.observacionController.text;
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

                          final res=await DBProvider.db.insertguard(guardia);


                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Datos registrados correctamente localmente ',style: TextStyle(color: Colors.white),),
                            backgroundColor: Colors.green,
                          ),
                        );
                        provider.getguardsavailable();
                        provider.formkey.currentState!.reset();
                        await Share.shareXFiles([XFile(provider.imagepath)],text: provider.Observacion);
                        Navigator.of(context).pop();

                    },
                  ),
                ),
              ),
              SizedBox(height: 20,)
              
          
              
            
              
              
          ],
          ),
        )
      ),
    );
  }
}
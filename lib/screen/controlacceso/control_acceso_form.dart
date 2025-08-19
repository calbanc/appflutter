import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/response/response.dart';
class controlAccesoForm extends StatefulWidget {
    final controlAccesoProvider provider;
  const controlAccesoForm({super.key,required this.provider});

  @override
  State<controlAccesoForm> createState() => _controlAccesoFormState();
}

class _controlAccesoFormState extends State<controlAccesoForm> {
  bool clienteselecionado=false;
  int idclient=0;
  List<Zona>listazonas=[];


  actualizalista ( List<Zona> lista) async{
    setState(() {
      listazonas=lista;
    });
  }
  @override
  Widget build(BuildContext context) {
  
  final picker = new ImagePicker();
  TextStyle styletext=TextStyle(color: Colors.white);
  




    void _showActionSheet(context,String tipo) {
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
                  tipo=='guia' ? widget.provider.imagepathguia = pickedFile.path 
                  :  tipo=='producto' ? widget.provider.imagepathproducto = pickedFile.path 
                  : widget.provider.imagepathfactura=pickedFile.path;
                  
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Acceso',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: ()async{
                showDialog(context: context, builder: ((context) {
                  return  CupertinoAlertDialog(
                    content: Column(children: const [
                      CupertinoActivityIndicator(),
                      Text('Registrando datos'),
                    ],),
                  );
                }));

                String fecha=DateFormat('dd/MM/yyyy').format(DateTime.now());
                String hora=DateFormat('HH:mm:ss').format(DateTime.now());
                String nombrefotoguia=fecha.replaceAll("/", "")+hora.replaceAll(":", "")+'guia';
                String nombrefotofactura=fecha.replaceAll("/", "")+hora.replaceAll(":", "")+'fact';
                String nombrefotoproducto=fecha.replaceAll("/", "")+hora.replaceAll(":", "")+'pro';
                String nombrefototransporte=fecha.replaceAll("/", "")+hora.replaceAll(":", "")+'trans';
                widget.provider.nombrefotoguia=nombrefotoguia;
                widget.provider.nombrefotofactura=nombrefotofactura;
                widget.provider.nombrefotoproducto=nombrefotoproducto;
                widget.provider.nombrefototransporte=nombrefototransporte;

                http.Response respuesta=await widget.provider.saveacceso(widget.provider);
                Navigator.of(context, rootNavigator: true).pop();
                if(respuesta.statusCode==200){

                  showDialog(context: context, builder: ((context) {
                    return  CupertinoAlertDialog(
                      content: Column(children: const [
                        CupertinoActivityIndicator(),
                        Text('Enviando imagenes'),
                      ],),
                    );
                  }));

                  widget.provider.imagepathguia!=''? await widget.provider.uploadImage(widget.provider.imagepathguia, nombrefotoguia): null;
                  widget.provider.imagepathfactura!='' ? await  widget.provider.uploadImage(widget.provider.imagepathfactura, nombrefotofactura):null;
                  widget.provider.imagepathproducto!='' ? await widget.provider.uploadImage(widget.provider.imagepathproducto,nombrefotoproducto):null;
                  widget.provider.imagepathproducto!='' ? await widget.provider.uploadImage(widget.provider.imagepathproducto,nombrefototransporte):null;


                  Navigator.of(context, rootNavigator: true).pop();

                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Registro exitoso',
                      text: 'Se ha registrado correctamente'
                  );


                  Navigator.pushReplacementNamed(context, 'maincontrol');

                }else{
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error en envio',
                      text: respuesta.body
                  );
                }
                
                
              },
              child: Text('Guardar',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          )
        ],
        
        ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FutureBuilder(
                future: widget.provider.getclientes(), 
                builder: (context, snapshot)  {

                  if(!snapshot.hasData){
                    return CupertinoActivityIndicator(); 
                  }else{
                    http.Response data=snapshot.data!;
                    if(data.statusCode==200){
                      final respuestab=ClientsbyCompanyResponse.fromJson(data.body);

                      List<Client>lista=respuestab.clientes;
                       return Padding(
                         padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                         child: DropdownSearch<Client>(
                            validator: (value)  {
                              return (value == null)
                                    ? 'Debe seleccionar cliente'
                                    : null;
                            },
                            popupProps: const PopupProps.dialog(
                                title: Text('Seleccione cliente'),
                                showSearchBox: true,
                                isFilterOnline: true),
                            items: lista!,
                            itemAsString: (Client u) =>
                                                u.name!,

                            dropdownDecoratorProps:  DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                       borderRadius: BorderRadius.circular(15),
                                      ),
                                  labelText: "Seleccione Cliente"),
                            ),
                            onChanged: (Client? value) async  {

                                  
                                    
                                    http.Response respuesta=await widget.provider.getzonbyclients(value!.id);
                                   if(respuesta.statusCode==200){
                                        ZonebyClientResponse response=ZonebyClientResponse.fromJson(respuesta.body);
                                        List<Zona>lista=response.data!;

                                        await actualizalista(lista);
                                        
                                        //Navigator.of(context, rootNavigator: true).pop();

                                    }else{
                                      //Navigator.of(context, rootNavigator: true).pop();
                                    } 
                                    widget.provider.idclient=value!.id;
                                    
                                    
                            },


                          ),
                       );
                    }else{
                        return Container();
                    
                    }
                    
                  }
                }),

      
              
               listazonas.isNotEmpty ?  Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                  child: DropdownSearch<Zona>(
                              key: widget.provider.formkeycuartel,
                              validator: (value)  {
                                return (value == null)
                                    ? 'Debe seleccionar zona del cliente'
                                    : null;
                              },
                              popupProps: const PopupProps.dialog(
                                  title: Text('Seleccione zona'),
                                  showSearchBox: true,
                                  isFilterOnline: true),
                              items: listazonas,
                              itemAsString: (Zona u) =>
                              u.name!,
                  
                              dropdownDecoratorProps:  DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Seleccione zona'),
                              ),
                              onChanged: (Zona? value) {
                                widget.provider.idzona=value!.id!;

                                
                  
                              },
                  
                  
                            ),
                ):Container(), 
                


              Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.rutvisita=value.trim();
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                    
                    
                    labelText: 'Rut Visita',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.nombrevisita=value;
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.input_outlined),
                    
                    
                    labelText: 'Nombre Visita',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.movitovisita=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Motivo Visita',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.patenteVehiculo=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Patente Vehiculo',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.patenteCarro=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Patente Carro',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value) => {
                  widget.provider.ingresoProducto=value,
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Ingreso producto',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.retiroProducto=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Retira producto',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.nguia=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Nro Guia',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
               Padding(
                padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                child: TextFormField(
                onChanged: (value){
                  widget.provider.nfactura=value;
                },
                decoration: InputDecoration(
                    /* errorText: 'Debe ingresar una observacion',
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ), */
                    
                    labelText: 'Nro Factura',
                    // Set border for enabled state (default)
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Set border for focused state
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    )), 
                ),
              ),
              Center(child: Text('Foto guia')),
              widget.provider.imagepathguia=='' ? Center():Center(
                          child: Image.file(
                            File(widget.provider.imagepathguia),
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.4,
                          ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: ElevatedButton(
                  onPressed:()=>_showActionSheet(context, 'guia') ,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                   child: Text('Foto guia',style: styletext,))),
              SizedBox(height: 10,),
              Center(child: Text('Foto factura')),
              widget.provider.imagepathfactura=='' ? Center():Center(
                          child: Image.file(
                            File(widget.provider.imagepathfactura),
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.4,
                          ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: ElevatedButton(
                  onPressed: ()=>_showActionSheet(context, 'factura'), 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Foto factura',style: styletext,))),
              SizedBox(height: 10,),
              Center(child: Text('Foto producto')),
              widget.provider.imagepathproducto=='' ? Center():Center(
                          child: Image.file(
                            File(widget.provider.imagepathproducto),
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.4,
                          ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: ElevatedButton(
                  
                  onPressed: ()=>_showActionSheet(context, 'producto'), 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Foto producto',style: styletext))
                  
                  ),
                SizedBox(height:20),
              Center(child: Text('Foto transporte')),
              widget.provider.imagepathtransporte=='' ? Center():Center(
                child: Image.file(
                  File(widget.provider.imagepathtransporte),
                  width: MediaQuery.of(context).size.width*0.4,
                  height: MediaQuery.of(context).size.height*0.4,
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: ElevatedButton(

                      onPressed: ()=>_showActionSheet(context, 'trasporte'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Foto transporte',style: styletext))

              ),
              SizedBox(height:20),


            ],
          ),
        ),
      ),

    );
  }
}
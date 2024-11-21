import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rondines/provider/provider.dart';
import 'package:rondines/response/ZonebyClientResponse.dart';
import 'package:rondines/response/response.dart';
import 'package:rondines/screen/controlacceso/control_acceso_form.dart';
import 'package:rondines/screen/registr_control.dart';
import 'package:http/http.dart' as http;

class MainControl extends StatelessWidget {
  const MainControl({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>controlAccesoProvider(),
      child: _MainControl(),
    );
  }
}

class _MainControl extends StatelessWidget {
  const _MainControl({super.key});

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<controlAccesoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Acceso'),
        centerTitle: true,
        actions: [
        //  IconButton(onPressed: (){}, icon: Icon(Icons.filter_list_alt))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child:const Icon(Icons.add,color: Colors.white,),
        onPressed: (){
           Navigator.push(context,
             MaterialPageRoute(
            builder: (context) =>  controlAccesoForm(provider: provider,)));
          
        }
      ),
      


      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        

        child: SingleChildScrollView(
          child: Column(children: [
              FutureBuilder(
                  future: provider.getclientes(), 
                  builder: (context, snapshot)  {
          
                    if(!snapshot.hasData){
                      return CupertinoActivityIndicator(); 
                    }else{
                      http.Response data=snapshot.data!;
                      if(data.statusCode==200){
                        final respuestab=ClientsbyCompanyResponse.fromJson(data.body);
          
                        List<Client>lista=respuestab.clientes;
                         return Padding(
                           padding:const  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
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
                              onChanged: (Client? value) async {
                                provider.idclientb=value!.id;
                                
            //                            obtenerzonasporcliente(value!.id);

                                http.Response respuesta=await provider.getvisits(value.id!);
                                if(respuesta.statusCode==200){
                                    VisitByclientResponse response=VisitByclientResponse.fromJson(respuesta.body);
                                    provider.listvisit=response.data!;
          
                                  
                                }
                                
                              },
          
          
                            ),
                         );
                      }else{
                          return Container();                        
                      }
                      
                    }
                  }), 
          
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-50,
                    
                    child: ListView.builder(
                      itemCount: provider.listvisit.length,
                      itemBuilder: (context, index) {
                        String rutvisita=provider.listvisit[index].rutvisita!;
                        String nombrevisita=provider.listvisit[index].nombrevisita!;
                        String patente=provider.listvisit[index].patentevehiculo!;
                        String motivo=provider.listvisit[index].motivovisita!;
                        DateTime fecha=provider.listvisit[index].fechaingreso!;
                        String hora=provider.listvisit[index].horaingreso!;
                        String date=DateFormat('dd-MM-yyyy').format(fecha);
                        int id=provider.listvisit[index].id!;
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('Visita:  $rutvisita - $nombrevisita'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child: Text('Motivo: $motivo'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('Fecha y hora: $date $hora'),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                                            onPressed: ()async{



                                            }, child: Text('Eliminar',style: TextStyle(color: Colors.white),)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            onPressed: ()async{
                                                http.Response response=await provider.darsalida(id);
                                                if(response.statusCode==200){
                                                  QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType.success,
                                                      title: 'Salida',
                                                      text: 'Salida generada correctamente'
                                                  );
                                                  provider.listvisit.removeWhere((element) => element.id==id);

                                                }



                                            }, child: Text('DAR SALIDA',style: TextStyle(color: Colors.white),)
                                        ),
                                      )
                                    ],
                                  )
                                                
                                ],

                              ),
                            ),
                          ),
                        );
                      } 
                      ),
                  ),
                  
          
          
          
          ]),
        ) ,
      ),
    );
  }
}

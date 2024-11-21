import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/reporteRondaProvider.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/response/ClientsbyCompanyResponse.dart';
import 'package:rondines/response/response.dart';
import 'package:rondines/screen/screen.dart';
class ReporteRondasScreen extends StatelessWidget {
  const ReporteRondasScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider(
        create: (_)=>ReporteRondaProvider(),
        child: _ReporteRondasScreen(),
    );
  }
}

class _ReporteRondasScreen extends StatefulWidget {
  const _ReporteRondasScreen({super.key});

  @override
  State<_ReporteRondasScreen> createState() => _ReporteRondasScreenState();
}

class _ReporteRondasScreenState extends State<_ReporteRondasScreen> {
  TextEditingController datectrl = TextEditingController(text:DateFormat('yyyy-MM-dd').format(DateTime.now()));
  @override
  Widget build(BuildContext context) {
    
    final provider=Provider.of<ReporteRondaProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title:const Text('Reporte de Rondas'),
        centerTitle: true,
        
      ),

      body: SingleChildScrollView(
        child: Column(children: [
          FutureBuilder(
            future: provider.getclient(), 
            builder: (context,snapshot){
              if(snapshot.hasData){
                  http.Response response=snapshot.data!;
                  if(response.statusCode==200){
                    ClientsbyCompanyResponse clientes=ClientsbyCompanyResponse.fromJson(response.body);
                    List<Client>listaclientes=clientes.clientes!;
                    
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
                              items: listaclientes!,
                              itemAsString: (Client u) =>
                                                  u.name!,
        
                              dropdownDecoratorProps:  DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                         borderRadius: BorderRadius.circular(15),
                                        ),
                                    labelText: "Seleccione Cliente",
                                    labelStyle:TextStyle(color: Colors.black,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue'))
                              ),
                              onChanged: (Client? value) async  {
        
                                    provider.idclient=value!.id;
                                      
                                      
                              },
        
        
                            ));
        
                  }else{
                    return Text('sin cliente');
                  }
              }else{
                return CupertinoActivityIndicator();
        
              }
        
              
            }
          ),
          
          Padding(
                  padding:  EdgeInsets.symmetric(vertical: 0,horizontal: 18),
                  child: TextFormField(
                    controller: datectrl,
                    expands: false,
                    onChanged: (value) => { 
                      provider.fecha=datectrl.text,
                    },
                    autofocus: false,
                    onSaved: (newValue) => {datectrl.text},
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
        
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),),
                      labelText: "Fecha",
                      labelStyle: TextStyle(color: Colors.black,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'ComicNeue')
                      ,
                    ),
                    validator: (value){
                      return (value==null)?'Debe seleccionar una Fecha Inicio':null;
                    },
                    onTap: () async {
                      datectrl.text = "";
        
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? datepicker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
        
                      if (datepicker != null) {
                        setState(() {
                          //datectrl.text=date!.toIso8601String();
                          
                          datectrl.text =
                              DateFormat('yyyy-MM-dd').format(datepicker);
                          //provider.fecha=datectrl.text;
                        });
                      }
                    },
                  ),
                ),
                 SizedBox(
                  width: MediaQuery.of(context).size.width,
                   child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                    child: CupertinoButton(
                      color: Colors.green,
                      onPressed: ()async{
                          provider.isloading=true;

                          http.Response response=await provider.serchbycompanyclient(datectrl.text, provider.idclient);
                          if(response.statusCode==200){
                            ReportClientResponse respuesta=ReportClientResponse.fromJson(response.body);
                            provider.reporte=respuesta.data!;
                            provider.isloading=false;
        
        
                          }else{
                            provider.isloading=false;
                            QuickAlert.show(
                              context: context, 
                              type: QuickAlertType.error,
                              title: 'Error en consulta de reportes',
                              text: response.body
                            );
                          }
        
        
                      },
                      child: provider.isloading ? CupertinoActivityIndicator(): Text('Mostrar',style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                                 ),
                 ),
        
                 SizedBox(
                  width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.5,
                   child: ListView.builder(
                    itemCount: provider.reporte.length,
                    itemBuilder: (context,index){
                      String observation=provider.reporte[index].observation!;
                      String puntocontrol=provider.reporte[index].puntocontrol!;
                      String rondin=provider.reporte[index].rondin!;
                      String zona=provider.reporte[index].zona!;
                      String hora=provider.reporte[index].time!;
                      String idimage=provider.reporte[index].idimage!;
                      String fecha=DateFormat('yyyy-MM-dd').format(provider.reporte[index].date!);
                      Report reporte=provider.reporte[index];
                      
                          return GestureDetector(
                              onTap: (){
                                print('dasd');
                                 Navigator.push(context, PageRouteBuilder(
                                  pageBuilder: ( _, __ , ___ ) => DetailReportScreen(reporte: reporte,),
                                  transitionDuration:const Duration( seconds: 3)
                              )
                              );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(70)),
                                          child: Image.network(
                                            'https://cliente.seguridadsegser.com/assets/rondas/$idimage.png'
                                          ),
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width*0.7,
                                              child: Text(puntocontrol,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                                          ),
                                          SizedBox(height:8,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text('Guardia : '+rondin,style: TextStyle(),),
                                          ),
                                          SizedBox(height:8,),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width*0.7,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Text('Observacion: '+observation),
                                            ),
                                          ),
                                          SizedBox(height:8,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text('Fecha y hora: $fecha $hora'),
                                          ),
                                          SizedBox(height:8,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text('Zona: $zona'),
                                          ),
                                          SizedBox(height: 10,),
                                        
                                          
                                                        
                                        ],
                                                                 
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                           
                    }
                                   ),
                 ),
        ]),
      ),
    );
  }
}
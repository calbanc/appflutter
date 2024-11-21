import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';


import '../../response/response.dart';


const   MAPBOX_ACCESS_TOKEN="pk.eyJ1IjoiY2FsYmFuYyIsImEiOiJjbHNtczVmbXcwbXp1MmxzY2FveTdqbGhmIn0.cJ7Iuo19UYU7BiDAqR7FpQ";

class DetailReportScreen extends StatelessWidget {
  final Report reporte;
  const DetailReportScreen({super.key,required this.reporte});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    String idimage=reporte.idimage!;
    String puntocontrol=reporte.puntocontrol!;
    String tipoguardia=reporte.typeguardia!;
    String observacion=reporte.observation!;
    String rondin=reporte.rondin!;
    String zona=reporte.zona!;
    String hora=reporte.time!;
    String fecha=DateFormat('yyyy-MM-dd').format(reporte.date!);
    String typoint=reporte.typepoint!;
    double latitud=reporte.lat!;
    double long=reporte.long!;
     final position=LatLng(latitud,long);

    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Control')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: 350,
              child:  Image.network(
                                             'https://cliente.seguridadsegser.com/assets/rondas/$idimage.png',
                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.orange,
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                              },
            )),

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( puntocontrol,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Agente de Seguridad: $rondin',style: TextStyle(fontSize: 15),),

            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Observacion : $observacion',style: TextStyle(fontSize: 15),),

            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Fecha $fecha $hora',style: TextStyle(fontSize: 15),),

            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Zona $zona',style: TextStyle(fontSize: 15),),

            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Tipo de punto: $tipoguardia',style: TextStyle(fontSize: 15),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text( 'Tipo de guardia: $typoint',style: TextStyle(fontSize: 15),),
            ),

            Center(
              child: SizedBox(
                width: width*0.9,
                height: 400,
                child: FlutterMap(
                options: MapOptions(
                  center: position,
                  minZoom: 5,
                  maxZoom: 25,
                  zoom: 18
                
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: const {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': 'mapbox/satellite-streets-v12'
                    },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                      point: position,
                      child: Icon(
                              Icons.location_pin,
                              color: Colors.red[900],
                              size: 40,
                            ),
                    )
                    ]
                  )
                  
                ],
                ),
              ),
            )
            


          ],
        ),
      ),
    );
  }
}
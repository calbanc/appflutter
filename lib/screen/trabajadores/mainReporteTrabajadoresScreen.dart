import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rondines/provider/controlAccesoProvider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:io' show Directory, File, Platform;
import '../../provider/reporteRondaProvider.dart';
import '../../response/ClientsbyCompanyResponse.dart';
import '../../response/ReportTrabajadoresResponse.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class mainReporteTrabajadoresScreen extends StatefulWidget {
  const mainReporteTrabajadoresScreen({super.key});

  @override
  State<mainReporteTrabajadoresScreen> createState() => _mainReporteTrabajadoresScreenState();
}

class _mainReporteTrabajadoresScreenState extends State<mainReporteTrabajadoresScreen> {
   String idclient='';
   bool isloading=false;
   late List<Listacceso> reporte=[];
    TextEditingController datectrl=TextEditingController();
   List<GridColumn>getColumns(){
     return <GridColumn>[
       GridColumn(
           autoFitPadding: EdgeInsets.all(10.0),
           columnName: 'Fecha',
           label: Center(child: Text('Fecha',style: TextStyle(fontWeight: FontWeight.bold),))
       ),
       GridColumn(
           columnName: 'Rut',
           autoFitPadding: EdgeInsets.all(10.0),
           label: Center(child: Text('Rut',style: TextStyle(fontWeight: FontWeight.bold),))),

       GridColumn(
           autoFitPadding: EdgeInsets.all(10.0),
           columnName: 'Trabajador',
           label: Center(child: Text('Trabajador',style: TextStyle(fontWeight: FontWeight.bold),))
       ),
       GridColumn(
           autoFitPadding: EdgeInsets.all(10.0),
           columnName: 'Ingreso',
           label: Center(child: Text('Ingreso',style: TextStyle(fontWeight: FontWeight.bold),))
       ),
       GridColumn(
           autoFitPadding: EdgeInsets.all(10.0),
           columnName: 'Salida',
           label: Center(child: Text('Salida',style: TextStyle(fontWeight: FontWeight.bold),))
       ),
       GridColumn(
           autoFitPadding: EdgeInsets.all(10.0),
           columnName: 'Patente',
           label: Center(child: Text('Patente',style: TextStyle(fontWeight: FontWeight.bold),))
       ),



     ];
   }




   createexcel(List<Listacceso> listado ,String nameexecel)async {
     Excel excel=Excel.createExcel();
     //excel.rename(excel.getDefaultSheet()!, "Informedeauditoria");
     Sheet  sheet=excel['Informe trabajadores'];
     //encabezado
     var cellsubitem=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
     cellsubitem.value  = TextCellValue("Fecha");
     var cellnomsubitem=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
     cellnomsubitem.value  = TextCellValue("Rut");
     var cellstock=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
     cellstock.value  = TextCellValue("Trabajador");
     var cellcantencontrada=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
     cellcantencontrada.value  = TextCellValue("Ingreso");
     var cellfecha=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
     cellfecha.value  = TextCellValue("Salida");
     var cellcantsustentada=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
     cellcantsustentada.value  = TextCellValue("Patente");

     var j=1;
     for (int i=0;i<listado.length;i++){
       var cellsubitem=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: j));
       cellsubitem.value  = TextCellValue(listado[i].fechaIngreso!);
       var cellnomsubitem=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: j));
       cellnomsubitem.value  = TextCellValue(listado[i].rut!);
       var cellstock=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: j));
       cellstock.value  = TextCellValue(listado[i].nombres!+' ' +listado[i].apellidopaterno!+' '+listado[i].apellidomaterno! );
       var cellcantencontrada=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: j));
       cellcantencontrada.value  = TextCellValue(listado[i].fechaIngreso!+' '+listado[i].horaIngreso!);

       var cellobservacion=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: j));
       cellobservacion.value  = TextCellValue(listado[i].fechaSalida==null ? '-' : listado[i].fechaSalida! +' ' +listado[i].horaSalida!);

       var cellcantsustentada=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: j));
       cellcantsustentada.value  = TextCellValue(listado[i].patente==null ? '-' : listado[i].patente! );


       j++;

     }




     var fileBytes = excel.save();
     var directory = (await getApplicationDocumentsDirectory()).path;
     if(fileBytes!=null){
       File(join('$directory/$nameexecel.xlsx'))
         ..createSync(recursive: true)
         ..writeAsBytesSync(fileBytes);

     }
     String path=join('$directory/$nameexecel.xlsx');
     await Share.shareXFiles([XFile(path)],text: 'xlsx');

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title:const Text('Reporte de Trabajadores',style: TextStyle(color: Colors.white),),
        iconTheme:const IconThemeData(color: Colors.white),

      ),
      body: Column(
        children: [


          Row(children: [
            Flexible(
              child: FutureBuilder(
                  future: ReporteRondaProvider().getclient(),
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
                                setState(() {
                                  idclient=value!.id.toString();
                                });
                                //    ReporteRondaProvider().idclient=value!.id;
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
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller: datectrl,
                  expands: false,
                  onChanged: (value) {
                    setState(() {
                      datectrl.text = value;
                    });

                  },
                  autofocus: false,
                  onSaved: (newValue) => {datectrl.text},
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.black)),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)),
                    ),
                    labelText: "Fecha",
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'ComicNeue'),
                  ),
                  validator: (value) {
                    return (value == null)
                        ? 'Debe seleccionar una Fecha Inicio'
                        : null;
                  },
                  onTap: () async {
                    datectrl.text = "";

                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? datepicker = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));

                    if (datepicker != null) {
                      setState(() {
                        datectrl.text =
                            DateFormat('yyyy-MM-dd').format(datepicker);
                      });

                      //provider.fecha=datectrl.text;
                    }
                  },
                ),
              ),
            )




          ],),
          
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                color: Colors.green,
                onPressed:isloading ? null : ()async {

                  isloading=true;
                  http.Response response =await controlAccesoProvider().getworkersaccesbydatereport(idclient,datectrl.text);

                  if(response.statusCode==200){
                    final re=reportTrabajadoresResponseFromMap(response.body);
                    setState(() {
                      reporte=re.listaccesos!;
                    });
                     //
                    // await createexcel(reporte, 'reporte');
                  }
                  isloading=false;

                },child: Text('MOSTRAR',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.7,
            child: SfDataGrid(

              columns: getColumns(),
              columnWidthMode: ColumnWidthMode.auto,

              source: ReporteStockDataGridSource(reporte),

            ),
          )

        ],


      ),
    );
  }
}

class ReporteStockDataGridSource extends DataGridSource {
  late List<DataGridRow> dataGridRow;
  late List<Listacceso> listatotales;

  List<DataGridRow> get rows => dataGridRow;
  NumberFormat f = new NumberFormat("#,##0.00", "es_AR");

  ReporteStockDataGridSource(this.listatotales) {
    buildDataGridRow();
  }


  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(cells: [


      Center(
        child: Container(
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Center(
        child: Container(
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Center(
        child: Container(
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Center(

        child: Container(
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,

          ),
        ),
      ),
      Center(

        child: Container(
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,

          ),
        ),
      ),
      Center(
        child: Container(
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ]);
  }

  void buildDataGridRow() {
    dataGridRow = listatotales.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Fecha', value: dataGridRow.fechaIngreso),
        DataGridCell(columnName: 'Rut', value: dataGridRow.rut),
        DataGridCell(columnName: 'Trabajador',
            value: dataGridRow.nombres! + " " + dataGridRow.apellidopaterno! +
                ' ' + dataGridRow.apellidomaterno!),

        DataGridCell(columnName: 'Ingreso',
            value: dataGridRow.fechaIngreso! + ' ' + dataGridRow.horaIngreso!),
        DataGridCell(columnName: 'Salida',
            value: dataGridRow.fechaSalida!=null ? dataGridRow.fechaSalida!  + ' ' + dataGridRow.horaSalida! : '' ),
        DataGridCell(columnName: 'Patente', value: dataGridRow.patente),


      ]);
    }).toList(growable: false);
  }

}
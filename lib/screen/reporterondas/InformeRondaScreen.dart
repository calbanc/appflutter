import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import '../../provider/reporteRondaProvider.dart';
import '../../response/ClientsbyCompanyResponse.dart';
import 'package:http/http.dart' as http;

import '../../response/reportClientResponse.dart';

import '../common/save_file_mobile.dart' as helper;

class InformeRondaScreen extends StatefulWidget {
  const InformeRondaScreen({super.key});

  @override
  State<InformeRondaScreen> createState() => _InformeRondaScreenState();
}

class _InformeRondaScreenState extends State<InformeRondaScreen> {
  TextEditingController datectrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  int idclient = 0;
  bool cargando = false;
  List<Report> reporte = [];
  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          autoFitPadding: EdgeInsets.all(10.0),
          columnName: 'Evidencia',
          label: Center(
              child: Text(
            'Evidencia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
      GridColumn(
          columnName: 'Hora',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Center(
              child: Text(
            'Hora',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
      GridColumn(
          autoFitPadding: EdgeInsets.all(10.0),
          columnName: 'Zona',
          label: Center(
              child: Text(
            'Zona',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
      GridColumn(
          autoFitPadding: EdgeInsets.all(10.0),
          columnName: 'Punto de Control',
          label: Center(
              child: Text(
            'Punto de Control',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
      GridColumn(
          autoFitPadding: EdgeInsets.all(10.0),
          columnName: 'Observacion',
          label: Center(
              child: Text(
            'Observacion',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
      GridColumn(
          autoFitPadding: EdgeInsets.all(10.0),
          columnName: 'Tipo Guardia',
          label: Center(
              child: Text(
            'Tipo Guardia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
    ];
  }

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  Future<void> exportDataGridToPdf() async {
    final ByteData data = await rootBundle.load('assets/segser.png');

    final PdfDocument document = _key.currentState!.exportToPdfDocument(
        fitAllColumnsInOnePage: true,
        cellExport: (DataGridCellPdfExportDetails details) async {},
        headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
          final double width = details.pdfPage.getClientSize().width;
          final PdfPageTemplateElement header =
              PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

          header.graphics.drawImage(
              PdfBitmap(data.buffer
                  .asUint8List(data.offsetInBytes, data.lengthInBytes)),
              Rect.fromLTWH(width - 148, 0, 148, 60));

          header.graphics.drawString(
            'Informe de Ronda',
            PdfStandardFont(PdfFontFamily.helvetica, 13,
                style: PdfFontStyle.bold),
            bounds: const Rect.fromLTWH(0, 25, 200, 60),
          );

          details.pdfDocumentTemplate.top = header;
        });
    // final List<int> bytes = await document.save();
    final List<int> bytes = await document.save();
    // File('output.pdf').writeAsBytes(bytes);
    // await helper.FileSaveHelper.save(bytes, 'DataGrid.pdf');

    // await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    //  document.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Informe de ronda',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: ReporteRondaProvider().getclient(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    http.Response response = snapshot.data!;
                    if (response.statusCode == 200) {
                      ClientsbyCompanyResponse clientes =
                          ClientsbyCompanyResponse.fromJson(response.body);
                      List<Client> listaclientes = clientes.clientes!;
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          child: DropdownSearch<Client>(
                            validator: (value) {
                              return (value == null)
                                  ? 'Debe seleccionar cliente'
                                  : null;
                            },
                            popupProps: const PopupProps.dialog(
                                title: Text('Seleccione cliente'),
                                showSearchBox: true,
                                isFilterOnline: true),
                            items: listaclientes!,
                            itemAsString: (Client u) => u.name!,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: "Seleccione Cliente",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: 'ComicNeue'))),
                            onChanged: (Client? value) async {
                              setState(() {
                                idclient = value!.id;
                              });
                              //    ReporteRondaProvider().idclient=value!.id;
                            },
                          ));
                    } else {
                      return Text('sin cliente');
                    }
                  } else {
                    return CupertinoActivityIndicator();
                  }
                }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
              child: TextFormField(
                controller: datectrl,
                expands: false,
                onChanged: (value) => {
                  ReporteRondaProvider().fecha = datectrl.text,
                },
                autofocus: false,
                onSaved: (newValue) => {datectrl.text},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(color: Colors.black)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
                      //provider.fecha=dateictrl.text;
                    });
                  }
                },
              ),
            ),
            MaterialButton(
              onPressed: () async {
                exportDataGridToPdf();
              },
              child: Text('Descargar '),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: () async {
                    setState(() {
                      cargando = true;
                    });
                    http.Response response = await ReporteRondaProvider()
                        .serchbycompanyclient(datectrl.text, idclient);
                    setState(() {
                      cargando = false;
                    });

                    if (response.statusCode == 200) {
                      ReportClientResponse respuesta =
                          ReportClientResponse.fromJson(response.body);
                      setState(() {
                        reporte = respuesta.data!;
                      });
                    } else {}
                  },
                  child: cargando
                      ? CupertinoActivityIndicator()
                      : Text(
                          'CONSULTAR',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              child: SfDataGrid(
                key: _key,
                columns: getColumns(),
                columnWidthMode: ColumnWidthMode.auto,
                source: ReporteStockDataGridSource(reporte),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReporteStockDataGridSource extends DataGridSource {
  late List<DataGridRow> dataGridRow;
  late List<Report> listatotales;
  List<DataGridRow> get rows => dataGridRow;
  NumberFormat f = new NumberFormat("#,##0.00", "es_AR");
  ReporteStockDataGridSource(this.listatotales) {
    buildDataGridRow();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(cells: [
      SizedBox(
        width: 50,
        height: 80,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(70)),
            child: CachedNetworkImage(
              imageUrl:
                  'https://cliente.seguridadsegser.com/assets/rondas/${row.getCells()[0].value.toString()}.png',
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
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
      SizedBox(
        width: 150,
        child: Container(
          child: Text(
            row.getCells()[3].value.toString(),
          ),
        ),
      ),
      SizedBox(
        width: 150,
        child: Container(
          child: Text(
            row.getCells()[4].value.toString(),
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
        DataGridCell(columnName: 'Evidencia', value: dataGridRow.idimage),
        DataGridCell(columnName: 'Hora', value: dataGridRow.time),
        DataGridCell(columnName: 'Zona', value: dataGridRow.zona),
        DataGridCell(
            columnName: 'Punto de Control', value: dataGridRow.puntocontrol),
        DataGridCell(columnName: 'Observacion', value: dataGridRow.observation),
        DataGridCell(
            columnName: 'Tipo Guardia', value: dataGridRow.typeguardia),
      ]);
    }).toList(growable: false);
  }
}

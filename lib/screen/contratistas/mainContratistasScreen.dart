import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/trabajadorescontratistas_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/response/RegistrosaccesocontratistaResponse.dart';

import '../../provider/provider.dart';

class MainContratistasScreen extends StatelessWidget {
  const MainContratistasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrabajadoresContratistasProvider(),
      child: const _MainContratistasScreen(),
    );
  }
}

class _MainContratistasScreen extends StatelessWidget {
  const _MainContratistasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrabajadoresContratistasProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ingreso de Contratistas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FutureBuilder(
                        future: provider.getclientes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            http.Response response = snapshot.data!;
                            if (response.statusCode == 200) {
                              ClientsbyCompanyResponse clientes =
                                  ClientsbyCompanyResponse.fromJson(
                                      response.body);
                              List<Client> listaclientes = clientes.clientes;

                              return DropdownSearch<Client>(
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
                                itemAsString: (Client u) => u.name,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        labelText: "Seleccione Cliente",
                                        labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'ComicNeue'))),
                                onChanged: (Client? value) async {
                                  provider.idclient = value!.id;
                                },
                              );
                            } else {
                              return const Text('sin cliente');
                            }
                          } else {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        }),
                  )),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        controller: provider.datectrl,
                        expands: false,
                        onChanged: (value) => {
                          provider.datectrl.text = value,
                        },
                        autofocus: false,
                        onSaved: (newValue) => {provider.datectrl.text},
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
                          provider.datectrl.text = "";

                          DateTime? date = DateTime(1900);
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? datepicker = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          if (datepicker != null) {
                            provider.datectrl.text =
                                DateFormat('yyyy-MM-dd').format(datepicker);
                            //provider.fecha=datectrl.text;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: provider.isloading
                      ? null
                      : () async {
                          provider.isloading = true;
                          http.Response response =
                              await provider.getregistrosaccesocontratista(
                                  provider.idclient.toString(),
                                  provider.datectrl.text);
                          if (response.statusCode == 200) {
                            provider.isloading = false;
                            final responseprovider =
                                registrosaccesocontratistaResponseFromJson(
                                    response.body);
                            provider.listaacceso =
                                responseprovider.accesocontratista!;
                          } else {
                            provider.isloading = false;
                          }
                        },
                  child: provider.isloading
                      ? CupertinoActivityIndicator()
                      : const Text(
                          'MOSTRAR',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                  itemCount: provider.listaacceso.length,
                  itemBuilder: (context, index) {
                    String patente = provider.listaacceso[index].patente!;
                    String conductor =
                        provider.listaacceso[index].nombreConductor!;
                    String trabajador = provider.listaacceso[index].nombre!;
                    String horaingreso =
                        provider.listaacceso[index].horaIngreso!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Conductor: $conductor'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Patente: $patente'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Trabajador: $trabajador'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Hora Ingreso: $horaingreso'),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: MaterialButton(
                                  color: Colors.green,
                                  onPressed: () async {
                                    String idcontratista = provider
                                        .listaacceso[index].idContratista!
                                        .toString();
                                    http.Response response =
                                        await provider.darsalida(idcontratista);
                                    if (response.statusCode == 200) {
                                      http.Response response = await provider
                                          .getregistrosaccesocontratista(
                                              provider.idclient.toString(),
                                              provider.datectrl.text);
                                      if (response.statusCode == 200) {
                                        final responseprovider =
                                            registrosaccesocontratistaResponseFromJson(
                                                response.body);
                                        provider.listaacceso =
                                            responseprovider.accesocontratista!;
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Dar Salida a Conductor',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addcontratista');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

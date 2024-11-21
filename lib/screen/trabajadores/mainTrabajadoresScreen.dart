import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rondines/response/accesoResponse.dart';

import 'package:rondines/response/trabajadoresResponse.dart';

import '../../provider/provider.dart';

class MainTrabajadoresScreen extends StatelessWidget {
  const MainTrabajadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => controlAccesoProvider(),
      child: const AsistenciaTrabajadoresScreen(),
    );
  }
}

class AsistenciaTrabajadoresScreen extends StatelessWidget {
  const AsistenciaTrabajadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<controlAccesoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Asistencia trabajadores',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (provider.idclient != 0) {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.loading,
                title: 'Tarjeta de trabajador',
                text: 'Acerque tarjeta de trabajador ');

            NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
              Uint8List identifier =
                  Uint8List.fromList(tag.data["nfca"]['identifier']);

              provider.nfc = HEX.encode(identifier);
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          addAsistencia(provider: provider),
                      transitionDuration: const Duration(seconds: 3)));
            });
          } else {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: 'Debe seleccionar un cliente antes ');
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.nfc_rounded,
          color: Colors.white,
        ),
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
                  )
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
                          http.Response response =
                              await provider.getworkersaccesbydate();

                          if (response.statusCode == 200) {
                            final workerslist =
                                accesoResponseFromMap(response.body);
                            provider.listaccesos = workerslist.listaccesos!;
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 600,
              child: ListadoWorkers(
                provider: provider,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class addAsistencia extends StatelessWidget {
  controlAccesoProvider provider;
  addAsistencia({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'REGISTRAR ASISTENCIA',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: provider.getdatatrabajador(),
          builder: (BuildContext context,
              AsyncSnapshot<TrabajadorResponse> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              if (snapshot.data!.trabajdores!.isNotEmpty) {
                Trabajdore? trabajador = snapshot.data!.trabajdores![0];
                List<Acceso> acceso = snapshot.data!.acceso!;
                provider.nombrectrl.text =
                    '${trabajador.nombres!} ${trabajador.apellidopaterno!} ${trabajador.apellidomaterno!}';
                provider.rutctrl.text = trabajador.rut!;
                provider.cargoctrl.text = trabajador.cargo!;
                provider.areactrl.text = trabajador.area!;

                if (acceso.isNotEmpty) {
                  provider.ingresoctrl.text = acceso.isEmpty
                      ? ''
                      : acceso[0].fechaIngreso! + ' ' + acceso[0].horaIngreso!;
                  provider.idregistroctrl.text =
                      acceso.isEmpty ? '' : acceso[0].id.toString();
                  return FormularioTrabajadoresScreen(
                    provider: provider,
                    salida: true,
                    acces: acceso[0],
                  );
                } else {
                  return FormularioTrabajadoresScreen(
                      provider: provider, salida: false);
                }
              } else {
                return const Center(
                    child: Text('TARJETA NFC NO HA SIDO REGISTRADA'));
              }
            }
          }),
    );
  }
}

class FormularioTrabajadoresScreen extends StatelessWidget {
  controlAccesoProvider provider;
  bool salida;
  Acceso? acces;
  FormularioTrabajadoresScreen(
      {Key? key, required this.provider, required this.salida, this.acces})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              readOnly: true,
              controller: provider.rutctrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                labelText: "Rut Trabajador",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              readOnly: true,
              controller: provider.nombrectrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                labelText: "Nombre Trabajador",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              onChanged: (value){
                if(value!=null){
                  provider.patentectrl.text=value;
                }
              },
              controller: provider.patentectrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,

                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                labelText: "Patente",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              readOnly: true,
              controller: provider.cargoctrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                labelText: "Cargo",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              readOnly: true,
              controller: provider.areactrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                labelText: "Area",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'ComicNeue'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          salida
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: provider.ingresoctrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: "Ingreso anterior",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'ComicNeue'),
                    ),
                  ),
                )
              : Container(),
          salida
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    controller: provider.idregistroctrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: "Id Ingreso anterior",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'ComicNeue'),
                    ),
                  ),
                )
              : Container(),
          salida
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: 'Registrar Salida',
                          text: 'Esta seguro de registrar la salida',
                          confirmBtnText: 'Dar Salida',
                          cancelBtnText: 'Cancelar',
                          onConfirmBtnTap: () async {
                            http.Response response = await provider
                                .getoutworker(provider.idregistroctrl.text);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      color: Colors.red,
                      child: const Text(
                        'REGISTRAR SOLO SALIDA',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                onPressed: provider.isloading
                    ? null
                    : () async {
                        provider.isloading = true;
                        http.Response response =
                            await provider.saveaccesworker();
                        if (response.statusCode == 200) {
                          provider.isloading = false;
                          Navigator.of(context).pop();
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: 'Ingreso',
                              text: 'Ingreso registrado correctamente',
                              confirmBtnText: 'Aceptar');
                        } else {
                          provider.isloading = false;
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: 'Error registrando ingreso',
                              confirmBtnText: 'Aceptar');
                        }
                      },
                color: Colors.blue,
                child: provider.isloading
                    ? const CupertinoActivityIndicator()
                    : !salida
                        ? const Text(
                            'REGISTRAR INGRESO',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'REGISTRAR SALIDA E INGRESO',
                            style: TextStyle(color: Colors.white),
                          ),
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}

class ListadoWorkers extends StatelessWidget {
  controlAccesoProvider provider;
  ListadoWorkers({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: provider.listaccesos.length,
        itemBuilder: (context, index) {
          String nombretrabajador = provider.listaccesos[index].nombres! +
              ' ' +
              provider.listaccesos[index].apellidopaterno! +
              ' ' +
              provider.listaccesos[index].apellidomaterno!;
          DateTime ingreso = provider.listaccesos[index].fechaIngreso!;
          String horaingreso = provider.listaccesos[index].horaIngreso!;
          DateTime? salida = provider.listaccesos[index].fechaSalida;
          String? horasalida = provider.listaccesos[index].horaSalida;
          String? patente = provider.listaccesos[index].patente;

          String id = provider.listaccesos[index].id.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 10),
                    child: Text('Trabajador: ' + nombretrabajador),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Fecha Ingreso:' + ingreso.toString()),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Hora Ingreso:' + horaingreso),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  patente!=null ? Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('Patente:' + patente!),
                  ): Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  salida != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('Fecha Salida:' + salida!.toString()),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  salida != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('Hora Salida:' + horasalida!.toString()),
                        )
                      : Container(),
                  salida == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: MaterialButton(
                              color: Colors.green,
                              onPressed: () async {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    confirmBtnText: 'Dar Salida',
                                    cancelBtnText: 'Cancelar',
                                    onConfirmBtnTap: () async {
                                      http.Response response =
                                          await provider.getoutworker(id);
                                      if (response.statusCode == 200) {
                                        http.Response response = await provider
                                            .getworkersaccesbydate();

                                        if (response.statusCode == 200) {
                                          final workerslist =
                                              accesoResponseFromMap(
                                                  response.body);
                                          provider.listaccesos =
                                              workerslist.listaccesos!;
                                        }
                                      }

                                      Navigator.of(context).pop();
                                    },
                                    title: 'Dar Salida',
                                    text:
                                        'Esta seguro de dar salida al trabajador');
                              },
                              child: Text(
                                'DAR SALIDA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/provider.dart';
import 'package:rondines/screen/RenovarTokenScreen.dart';
import 'package:rondines/ui/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final idrole;
  final idclient;
  const MenuScreen({super.key, required this.idrole, required this.idclient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: _MenuScreen(
        idrole: this.idrole,
        idclient: this.idclient,
      ),
    );
  }
}

class _MenuScreen extends StatelessWidget {
  final idrole;
  final idclient;
  const _MenuScreen({super.key, required this.idrole, required this.idclient});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final Future<SharedPreferences> shared_preferences =
        SharedPreferences.getInstance();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: general().getdateofexpiredtoken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DateTime tiempo = snapshot.data!;
              return Text(
                'Tu sesion expira : $tiempo',
                style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              );
            } else {
              return Text('');
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => RenovarTokenScreen(
                              idrole: this.idrole,
                              idclient: this.idclient,
                            ),
                        transitionDuration: const Duration(seconds: 3)));
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            onPressed: () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'Cerrar Sesion',
                  text: 'Esta seguro de cerrar sesion',
                  confirmBtnText: 'Cerrar',
                  cancelBtnText: 'Cancelar',
                  onConfirmBtnTap: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    SharedPreferences prefs = await shared_preferences;
                    await prefs.clear();
                    Navigator.pushReplacementNamed(context, 'login');
                  });
            },
            child: const Text(
              'CERRAR SESION',
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: FutureBuilder(
                  future: general().getnamefromtoken(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Hola..' +
                                snapshot.data! +
                                ' Bienvenido a SegSer App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 20),
                          ),
                        ),
                      );
                    } else {
                      return const CupertinoActivityIndicator();
                    }
                  }),
            ),
            idrole == 1 || idrole == 2
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'ronda');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.orangeAccent,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image: AssetImage('assets/nfc.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'CONTROL DE RONDAS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'maincontrol');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.indigo,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image: AssetImage(
                                                'assets/checkin.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'CONTROL DE ACCESO',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, 'asistenciatrabajadores');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.deepPurpleAccent,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image: AssetImage(
                                                'assets/asistencia.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'ASISTENCIA TRABAJADORES',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'contratistas');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.deepPurpleAccent,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image: AssetImage(
                                                'assets/trabajadores.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'CONTRATISTAS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'supervision');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.deepPurpleAccent,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image: AssetImage(
                                                'assets/asistencia.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'SUPERVISION CAMPOS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'check');
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.deepOrange,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: const FadeInImage(
                                            width: 180,
                                            height: 100,
                                            image:
                                                AssetImage('assets/check.png'),
                                            placeholder:
                                                AssetImage('assets/segser.png'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'CHECK IMPLEMENTOS RONDA',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Container(),
            idrole == 3 || idrole == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'reporte');
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.green,
                                elevation: 10,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: const FadeInImage(
                                        width: 180,
                                        height: 100,
                                        image: AssetImage('assets/maps.png'),
                                        placeholder:
                                            AssetImage('assets/segser.png'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'REPORTE DE RONDAS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'informe');
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.green,
                                elevation: 10,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: const FadeInImage(
                                        width: 180,
                                        height: 100,
                                        image: AssetImage('assets/report.png'),
                                        placeholder:
                                            AssetImage('assets/segser.png'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'INFORME DE RONDAS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
                : Container(),
            idrole == 3 || idrole == 1
                ? Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'reportetrabajadores');
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.green,
                                elevation: 10,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: const FadeInImage(
                                        width: 180,
                                        height: 100,
                                        image: AssetImage('assets/report.png'),
                                        placeholder:
                                            AssetImage('assets/segser.png'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'INFORME INGRESO DE TRABAJADORES',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

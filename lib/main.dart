import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/provider.dart';
import 'package:rondines/response/response.dart';
import 'package:rondines/screen/CheckTokenScreen.dart';
import 'package:rondines/screen/Login_screen.dart';
import 'package:rondines/screen/Ronda_screen.dart';
import 'package:rondines/screen/contratistas/contratistasScreen.dart';
import 'package:rondines/screen/contratistas/mainContratistasScreen.dart';
import 'package:rondines/screen/controlacceso/control_acceso_form.dart';
import 'package:rondines/screen/menu_screen.dart';
import 'package:rondines/screen/registr_control.dart';
import 'package:rondines/screen/screen.dart';
import 'package:rondines/screen/supervision/mainSupervisionScreen.dart';
import 'package:rondines/screen/trabajadores/mainReporteTrabajadoresScreen.dart';

void main() {
  runApp(Myapp());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => new LoginProvider())),
      ],
      child: Myapp(),
    );
  }
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SegSer',
      initialRoute: 'token',
      routes: {
        'token': (_) => CheckTokenScreen(),
        'login': (_) => LoginScreen(),
        'ronda': (_) => Ronda_screen(),
        'registra': (_) => RegistrControl(),
        'scan': (_) => ScanScreen(),
        'maincontrol': (_) => MainControl(),
        'reporte': (_) => ReporteRondasScreen(),
        'asistencia': (_) => MainAsistencia(),
        'contratistas': (_) => MainContratistasScreen(),
        'addcontratista': (_) => ContratistasScreen(),
        'supervision': (_) => mainSupervisionScreen(),
        'menu': (_) => MenuScreen(
              idrole: 0,
              idclient: 0,
            ),
        'informe': (_) => InformeRondaScreen(),
        'asistenciatrabajadores': (_) => MainTrabajadoresScreen(),
        'reportetrabajadores': (_) => mainReporteTrabajadoresScreen()
      },
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
    );
  }
}

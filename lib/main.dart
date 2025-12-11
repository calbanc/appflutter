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
import 'package:rondines/screen/estadodron/checkScreen.dart';
import 'package:rondines/screen/menu_screen.dart';
import 'package:rondines/screen/registr_control.dart';
import 'package:rondines/screen/screen.dart';
import 'package:rondines/screen/supervision/mainSupervisionScreen.dart';
import 'package:rondines/screen/trabajadores/mainReporteTrabajadoresScreen.dart';

void main() {
  runApp(const Myapp());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => LoginProvider())),
      ],
      child: const Myapp(),
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
        'token': (_) => const CheckTokenScreen(),
        'login': (_) => const LoginScreen(),
        'ronda': (_) => const Ronda_screen(),
        'registra': (_) => const RegistrControl(),
        'scan': (_) => const ScanScreen(),
        'maincontrol': (_) => const MainControl(),
        'reporte': (_) => const ReporteRondasScreen(),
        'asistencia': (_) => const MainAsistencia(),
        'contratistas': (_) => const MainContratistasScreen(),
        'addcontratista': (_) => const ContratistasScreen(),
        'supervision': (_) => const mainSupervisionScreen(),
        'check': (_) => const CheckScreen(),
        'menu': (_) => const MenuScreen(
              idrole: 0,
              idclient: 0,
            ),
        'informe': (_) => const InformeRondaScreen(),
        'asistenciatrabajadores': (_) => const MainTrabajadoresScreen(),
        'reportetrabajadores': (_) => const mainReporteTrabajadoresScreen()
      },
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
    );
  }
}

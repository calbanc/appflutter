import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/provider.dart';
import 'package:rondines/screen/Login_screen.dart';

void main() {
  runApp( Myapp());
}

class AppState extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( (context) => new LoginProvider())),
       
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
      title:'SegSer',
      initialRoute: 'modulos',
      routes: {
        'login':( _ )=>LoginScreen(),
        
        
        
        
      },
      theme:ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
    );
  }
}
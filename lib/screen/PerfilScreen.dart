
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rondines/screen/RenovarTokenScreen.dart';
import 'package:rondines/screen/menu_screen.dart';
import 'package:rondines/ui/general.dart';

import '../provider/provider.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider(
      create: (_)=>MenuProvider(),
      child: _PerfilScreen(),
    );
  }
}

class _PerfilScreen extends StatelessWidget {
  const _PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([

        general().getidrolefromtoken(),
        general().getidclientfromtoken(),
        general().istokenexpired()
      ]), 
      builder: (context,snapshot){
        if(snapshot.hasData){
          
                    

          if(snapshot.data![2]==1) {
            Future.microtask(()  {

            Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: ( _, __ , ___ ) => RenovarTokenScreen(idrole: snapshot.data![0],idclient: snapshot.data![1],),
                transitionDuration:const Duration( seconds: 3)
            )
            );

          });
          }else{
            Future.microtask(()  {

            Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: ( _, __ , ___ ) => MenuScreen(idrole: snapshot.data![0],idclient: snapshot.data![1],),
                transitionDuration:const Duration( seconds: 3)
            )
            );

          });
          }

          

          return CupertinoActivityIndicator();
        }else{
          return CupertinoActivityIndicator();
        }
      }
    );
  }
}
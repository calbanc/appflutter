

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/LoginProvider.dart';
import 'package:rondines/screen/Login_screen.dart';
import 'package:rondines/screen/menu_screen.dart';
import 'package:rondines/screen/screen.dart';
import 'package:rondines/ui/general.dart';



class CheckTokenScreen extends StatelessWidget {
  const CheckTokenScreen({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
 
    return Container(
      height: 200,
      width: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/segser.png"),fit:BoxFit.contain,),
        color: Colors.white
        ),
        child: ChangeNotifierProvider(
          
          create: (_) => LoginProvider(),
                    child: _FutureBuilder() ,
        )
        
          , 
       );
       
  

  }
}

class _FutureBuilder extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginProvider>(context);
    return FutureBuilder(

          future: general().gettoken(),
          builder: (BuildContext context,snapshot){
             
             if(!snapshot.hasData) return const CupertinoActivityIndicator();

             if(snapshot.data==''){
              
              Future.microtask(() => {
                 Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => LoginScreen(),
                  transitionDuration:const Duration( seconds: 3)
                  )
                )

              });
             }else{ 


                 Future.microtask(()  {
                   
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => PerfilScreen(),
                  transitionDuration:const Duration( seconds: 3)
                  )
                ); 

              }); 
             }
             return Container();
          },
          );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/LoginProvider.dart';
import 'package:rondines/provider/db_provider.dart';
import 'package:rondines/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../services/notificatios_service.dart';
import '../ui/auth_backgroud.dart';
import '../ui/card_container.dart';
import '../ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.white,
      body: AuthBackground(child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 300),
            CardContainer(

              child: Column(
                children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Segser',
                      style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 25,),
                    ChangeNotifierProvider(
                        create: (_)=>LoginProvider(),
                        child: _LoginForm(),
                      )
                  ]
                )
            ),
            const SizedBox(height: 300,)
                ],
              )
            )
          
        ),
      );
  
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> shared_preferences = SharedPreferences.getInstance();
    final loginForm=Provider.of<LoginProvider>(context);
      return Container(
       child: Form(
        key: loginForm.formkey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                  hintext: 'Ingrese su Usuario',
                  labeltext: 'Usuario',
                  icono: Icons.person_pin_circle_outlined
              ),
              onChanged: (value)=>loginForm.USERNAME=value,
              validator: (value){
                return(value==null || value.isEmpty)? 'Debe ingresar un usuario valido' : null;
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              autocorrect: false,
              obscureText: loginForm.oscureText,
              decoration: InputDecorations.authInputDecoration(
                  hintext: 'Contraseña',
                  labeltext: 'Contraseña',
                  sufixiconobutton: IconButton(onPressed: (){

                    loginForm.oscureText=!loginForm.oscureText;

                  }, icon: const Icon(Icons.visibility_outlined))
              ),
              enableSuggestions: false,

              onChanged: (value)=>loginForm.PASSWORD=value,
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Debe ingresar un Password valido'
                    : null;
              },
            ),
            const SizedBox(height: 18,),
            MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                disabledColor: Colors.grey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                  child: loginForm.isLoading ? SizedBox(
                    //height: 50,
                    width: 50,
                    child: CupertinoActivityIndicator(),
                  ) : FittedBox(
                    fit: BoxFit.fill,
                    child: Text('INGRESAR',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
                color: Colors.blue,
              onPressed: loginForm.isLoading ? null: () async{
                String usuario=loginForm.USERNAME;
                String clave=loginForm.PASSWORD;
                if(!loginForm.isValidateForm())return;
                loginForm.isLoading=true;
                FocusScope.of(context).unfocus();

                http.Response respuesta=await loginForm.login(usuario, clave);

                if(respuesta.statusCode!=200){
                //  String mensaje='Porfavor revise su conexion';

              


                loginForm.isLoading=false;
                  QuickAlert.show(context: context,
                   type: QuickAlertType.error,
                   title: 'Login Error',
                   text:'Estimado usuario password incorrecto'                   
                  );
                }else{
                    final respueslogin=LoginResponse.fromJson(respuesta.body);
                  String token=respueslogin.token;
                  final SharedPreferences prefs = await shared_preferences;
                  prefs.setString('token', token!);


                  final http.Response respuestapoint=await loginForm.getpoints();
                  if(respuestapoint.statusCode==200){
                    final points=GetdatacodeResponse.fromJson(respuestapoint.body);
                    List<Point>listapoints=points.point!;
                    listapoints.forEach((element) async=> { 
                      await DBProvider.db.insertpoint(element)
                    });

                  }
                  final http.Response respuestatypeguard=await loginForm.gettypeguard();
                  if(respuestatypeguard.statusCode==200){
                    final tipoguardia=GettypeguardsbycompanyResponse.fromJson(respuestatypeguard.body);
                    List<TipoGuard>listatipo=tipoguardia.tipoguard!;
                    listatipo.forEach((element) async =>{
                      await DBProvider.db.inserttypeguard(element)
                    });
                  }


                    loginForm.isLoading=false;

                  Navigator.pushReplacementNamed(context, 'token');
                    
                   
                }

              }
              
            )
          ],)
      ),
    );
  }
}
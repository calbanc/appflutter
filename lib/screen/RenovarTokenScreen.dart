import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rondines/provider/LoginProvider.dart';
import 'package:rondines/ui/general.dart';
import 'package:rondines/ui/input_decorations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../response/response.dart';
class RenovarTokenScreen extends StatelessWidget {
  final idrole;
  final idclient;
  const RenovarTokenScreen({super.key,required this.idrole,required this.idclient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=>LoginProvider(),
        child: _RenovarTokenScreen(idrole: this.idrole,idclient: this.idclient,),
    );
  }
}


class _RenovarTokenScreen extends StatelessWidget {
  final idrole;
  final idclient;
  const _RenovarTokenScreen({super.key,required this.idrole,required this.idclient});

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> shared_preferences = SharedPreferences.getInstance();
    final provider=Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Renueva tu token'),
        centerTitle: true,

      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          FutureBuilder(
            future: general().getusername(),
            builder: (context,snapshot){

              if(snapshot.hasData){
                String username=snapshot.data!;
                provider.USERNAME=username;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      enabled: false,
                       decoration: InputDecorations.authInputDecoration(
                        hintext: 'Ingrese su Usuario',
                        labeltext: 'Usuario',
                        icono: Icons.person_pin_circle_outlined
                    ),
                      initialValue: username,
                    ),
                  ),
                );
              }else{
                return CupertinoActivityIndicator();
              }
            }
          ),

          SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             child: TextFormField(
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                decoration: InputDecorations.authInputDecoration(
                    hintext: 'Ingrese su clave',
                    labeltext: 'Password',
                    icono: Icons.logout
                ),
                onChanged: (value)=>provider.PASSWORD=value,
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Debe ingresar un Password valido'
                      : null;
                },
              ),
           ),
           SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  disabledColor: Colors.grey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                    child: provider.isLoading ? SizedBox(
                      //height: 50,
                      width: 50,
                      child: CupertinoActivityIndicator(),
                    ) : FittedBox(
                      fit: BoxFit.fill,
                      child: Text('INGRESAR',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  color: Colors.blue,
                onPressed: provider.isLoading ? null: () async{
                  FocusScope.of(context).unfocus(); 
                  String usuario=provider.USERNAME;
                  String clave=provider.PASSWORD;
                  if(clave.isEmpty) {
                    QuickAlert.show(context: context,
                     type: QuickAlertType.warning,
                     title: 'Ingrese su password'
                    );
                    return;
                  }
                  provider.isLoading=true;
                  
              
                  http.Response respuesta=await provider.login(usuario, clave);
              
                  if(respuesta.statusCode!=200){
                  //  String mensaje='Porfavor revise su conexion';
              
                
              
              
                  provider.isLoading=false;
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
                    provider .isLoading=false;
              
                    Navigator.pushReplacementNamed(context, 'token');
                      
                     
                  }
              
                }
                
              ),
            )
        ],
      ),
    );
  }
}
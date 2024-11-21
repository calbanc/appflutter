import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rondines/ui/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/response.dart';
class ReporteRondaProvider extends ChangeNotifier{
  int _idclient=0;
  int get idclient=>_idclient;
  String fecha='';
  List<Report>_reporte=[];
  bool _isloading=false;
  bool get isloading=>_isloading;
  List<Report> get reporte=>_reporte;

  set isloading(bool value){
    _isloading=value;
    notifyListeners();
  }

  set reporte(List<Report> value){
    _reporte=value;
    notifyListeners();
  }

  set idclient(int value){
    _idclient=value;
    notifyListeners();
  }



      Future<http.Response>getclient()async{
        int idcompany=await general().getidclientfromtoken();
         Map<String,dynamic> data={};
        String _endpoint='';
        if(idcompany==0){
            _endpoint = '/api/clients/searchbycompany';
             idcompany=await general().getidcompanyfromtoken(); 
            data={'IDCOMPANY':idcompany};
        }else{
          _endpoint = '/api/clients/findclient';
            data={'ID':idcompany};
        }
      
       final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final SharedPreferences prefs = await _prefs;

        final String? token=prefs.getString('token');

        String parametros=json.encode(data);


        final url = Uri.https(general().baseUrl, _endpoint);

        Map<String, String> header = new Map();
        header["content-type"] =  "application/x-www-form-urlencoded";
        header["Auth"] =  token!;
        final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});

        return response;
        
      }
      Future<http.Response>serchbycompanyclient(String fecha,int idclient)async{
        String _endpoint="/api/guards/serchbycompanyclientaprobados";
        final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final SharedPreferences prefs = await _prefs;

        final String? token=prefs.getString('token');
        
        int idcompany=await general().getidcompanyfromtoken();
        final Map<String,dynamic> data={'IDCOMPANY':idcompany,'IDCLIENT':idclient,'DATE':fecha,"VALIDADO":"1"};
        String parametros=json.encode(data);  
        

        final url = Uri.https(general().baseUrl, _endpoint);
        
        Map<String, String> header = new Map();
        header["content-type"] =  "application/x-www-form-urlencoded";  
        header["Auth"] =  token!;  
        final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});
        

        return response;
      }

}
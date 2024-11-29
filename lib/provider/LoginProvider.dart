import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rondines/response/LoginResponse.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/general.dart';
class LoginProvider extends ChangeNotifier{
  
  final String _baseUrl = "api.seguridadsegser.com";  
  
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  String USERNAME='';
  String PASSWORD='';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _oscureText=true;

  bool get oscureText=>_oscureText;

  set oscureText(value){
    _oscureText=value;
    notifyListeners();
  }
  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidateForm() {
    return formkey.currentState?.validate() ?? false;
  }


  Future<http.Response>login(String idusuario,String pass)async{
    const String _endpoint = '/api/login';
      final Map<String, dynamic> data = {'USERNAME': idusuario, 'PASSWORD': pass};
      final url = Uri.https(_baseUrl, _endpoint);
      String parametros = json.encode(data);
      final response = await http.post(url, body: {"json": parametros});
      return response;
  }

  Future<http.Response>getpoints()async{
    int idcompany=await general().getidcompanyfromtoken();
    String _endpoint="/api/point/getpointbycompany";

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');

    final Map<String,dynamic> data={'IDCOMPANY':idcompany};
    String parametros=json.encode(data);





    final url = Uri.https(general().baseUrl, _endpoint);

    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    header["Auth"] =  token!;
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});

    return response;

  }
  Future<http.Response>gettypeguard()async{
    int idcompany=await general().getidcompanyfromtoken();
    String _endpoint="/api/typeguard/gettypeguardsbycompany";

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');

    final Map<String,dynamic> data={'IDCOMPANY':idcompany};
    String parametros=json.encode(data);





    final url = Uri.https(general().baseUrl, _endpoint);

    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    header["Auth"] =  token!;
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});

    return response;

  }


}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rondines/response/LoginResponse.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class LoginProvider extends ChangeNotifier{
  
  final String _baseUrl = "api.seguridadsegser.com";  
  
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  String USERNAME='';
  String PASSWORD='';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  
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




}
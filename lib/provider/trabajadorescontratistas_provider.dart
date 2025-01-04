import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rondines/ui/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/RegistrosaccesocontratistaResponse.dart';

class TrabajadoresContratistasProvider extends ChangeNotifier {
  TextEditingController datectrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  int idclient = 0;

  bool _isloading = false;
  List<Accesocontratista> _listaacceso = [];
  List<Accesocontratista> get listaacceso => _listaacceso;

  bool get isloading => _isloading;

  set isloading(value) {
    _isloading = value;
    notifyListeners();
  }

  set listaacceso(value) {
    _listaacceso = value;
    notifyListeners();
  }

  Future<http.Response> getclientes() async {
    String _endpoint = "/api/clients/searchbycompany";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    int idcompany = await general().getidcompanyfromtoken();
    final Map<String, dynamic> data = {'IDCOMPANY': idcompany};
    String parametros = json.encode(data);
    final url = Uri.https(general().baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] = "application/x-www-form-urlencoded";
    header["Auth"] = token!;
    final response = await http
        .post(url, body: {"json": parametros}, headers: {"Auth": token!});
    return response;
  }

  Future<http.Response> getregistrosaccesocontratista(
      String idclient, String fecha) async {
    String _endpoint = "/api/accesocontratistas/getregistrosaccesocontratista";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    int idcompany = await general().getidcompanyfromtoken();
    final Map<String, dynamic> data = {
      'idclient': idclient,
      'fecha_ingreso': fecha
    };
    String parametros = json.encode(data);
    final url = Uri.https(general().baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] = "application/x-www-form-urlencoded";
    header["Auth"] = token!;
    final response = await http
        .post(url, body: {"json": parametros}, headers: {"Auth": token!});
    return response;
  }

  Future<http.Response> darsalida(String id_contratista) async {
    String _endpoint = "/api/accesocontratistas/darsalidacontratista";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());
    int idcompany = await general().getidcompanyfromtoken();
    final Map<String, dynamic> data = {
      'id_contratista': id_contratista,
      'fecha_salida': date,
      'hora_salida': time
    };
    String parametros = json.encode(data);
    final url = Uri.https(general().baseUrl, _endpoint);
    Map<String, String> header = new Map();
    header["content-type"] = "application/x-www-form-urlencoded";
    header["Auth"] = token!;
    final response = await http
        .post(url, body: {"json": parametros}, headers: {"Auth": token!});
    return response;
  }
}

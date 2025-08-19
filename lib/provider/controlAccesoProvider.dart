import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rondines/response/ZonebyClientResponse.dart';
import 'package:rondines/response/accesoResponse.dart';
import 'package:rondines/response/response.dart';
import 'package:rondines/response/trabajadoresResponse.dart';
import 'package:rondines/ui/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/contratistaResponse.dart';

class controlAccesoProvider extends ChangeNotifier {
  GlobalKey<DropdownSearchState> formkeycuartel =
      GlobalKey<DropdownSearchState>();
  TextEditingController datectrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController nombrectrl = TextEditingController();
  TextEditingController apellidosctrl = TextEditingController();
  TextEditingController rutctrl = TextEditingController();
  TextEditingController cargoctrl = TextEditingController();
  TextEditingController areactrl = TextEditingController();
  TextEditingController patentectrl = TextEditingController();
  TextEditingController ingresoctrl = TextEditingController();
  TextEditingController idregistroctrl = TextEditingController();
  TextEditingController observacionsalidactrl = TextEditingController();
  int idclient = 0;

  String rutvisita = '';
  String nombrevisita = '';
  String patenteVehiculo = '';
  String patenteCarro = '';
  String ingresoProducto = '';
  String retiroProducto = '';
  String movitovisita = '';
  String nombrefotoguia = '';
  String nombrefotofactura = '';
  String nombrefotoproducto = '';
  String nombrefototransporte = '';

  int idzona = 0;
  String nguia = '';
  String nfactura = '';
  String _imagepathguia = '';
  String _imagepathfactura = '';
  String _imagepathproducto = '';
  String _imagepathtransporte = '';

  String _nfc = '';
  String _qr = '';

  String get nfc => _nfc;
  String get qr => _qr;

  bool _isloading = false;

  bool get isloading => _isloading;

  set isloading(value) {
    _isloading = value;
    notifyListeners();
  }

  set nfc(String value) {
    _nfc = value;
    notifyListeners();
  }

  set qr(String value) {
    _qr = value;
    notifyListeners();
  }

  List<Listacceso> _listaccesos = [];

  List<Listacceso> get listaccesos => _listaccesos;

  set listaccesos(value) {
    _listaccesos = value;
    notifyListeners();
  }

  String get imagepathguia => _imagepathguia;
  String get imagepathfactura => _imagepathfactura;
  String get imagepathproducto => _imagepathproducto;
  String get imagepathtransporte => _imagepathtransporte;
  List<Zona> _listzona = [];
  List<Zona> get listzona => _listzona;

  List<Visit> _listvisit = [];
  List<Visit> get listvisit => _listvisit;

  int _idclientb = 0;
  int get idclientb => _idclientb;

  set listvisit(List<Visit> value) {
    _listvisit = value;
    notifyListeners();
  }

  set idclientb(int value) {
    _idclientb = value;
    notifyListeners();
  }

  set listzona(List<Zona> value) {
    _listzona = value;
    notifyListeners();
  }

  set imagepathguia(String value) {
    _imagepathguia = value;
    notifyListeners();
  }

  set imagepathfactura(String value) {
    _imagepathfactura = value;
    notifyListeners();
  }

  set imagepathproducto(String value) {

    _imagepathproducto = value;
    notifyListeners();
  }
  set imagepathtransporte(String value) {
    _imagepathtransporte = value;
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

  Future<http.Response> deletecontrol() async {
    String _endpoint = "/api/acceso/delete";
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

  Future<TrabajadorResponse> getdatatrabajador() async {
    String _endpoint = "/api/trabajadores/gettrabajadorebyclientnfc";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'idclient': idclient,
      'qr': qr,
      'nfc': nfc
    };
    String parametros = json.encode(data);

    final url = Uri.https(general().baseUrl, _endpoint);

    Map<String, String> header = new Map();
    header["content-type"] = "application/x-www-form-urlencoded";
    header["Auth"] = token!;
    final response = await http
        .post(url, body: {"json": parametros}, headers: {"Auth": token!});

    TrabajadorResponse trabajadorresponse =
        trabajadorResponseFromMap(response.body);

    return trabajadorresponse;
  }

  Future<http.Response> getzonbyclients(int idclient) async {
    String _endpoint = "/api/zone/getzonebyclient";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');
    print(token);

    int idcompany = await general().getidcompanyfromtoken();
    final Map<String, dynamic> data = {'IDCLIENT': idclient};
    String parametros = json.encode(data);

    final url = Uri.https(general().baseUrl, _endpoint);

    Map<String, String> header = new Map();
    header["content-type"] = "application/x-www-form-urlencoded";
    header["Auth"] = token!;
    final response = await http
        .post(url, body: {"json": parametros}, headers: {"Auth": token!});

    return response;
  }

  Future<http.Response> saveacceso(controlAccesoProvider provider) async {
    String _endpoint = "/api/acceso/register";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');

    int idcompany = await general().getidcompanyfromtoken();
    int iduser = await general().getiduserfromtoken();
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());

    final Map<String, dynamic> data = {
      'IDCOMPANY': idcompany,
      'IDCLIENT': provider.idclient,
      'IDZON': provider.idzona,
      'RUTVISITA': provider.rutvisita,
      'NOMBREVISITA': provider.nombrevisita,
      'MOTIVOVISITA': provider.movitovisita,
      'PATENTE': provider.patenteVehiculo,
      'FECHAINGRESO': date,
      'HORAINGRESO': time,
      'INGRESOPRODUCTO': provider.ingresoProducto,
      'RETIROPRODUCTO': provider.retiroProducto,
      'NGUIA': provider.nguia,
      'NFACTURA': provider.nfactura,
      'NOMBREFOTOGUIA': provider.nombrefotoguia,
      'NOMBREFOTOFACTURA': provider.nombrefotofactura,
      'NOMBREFOTOPRODUCTO': provider.nombrefotoproducto,
      'IDUSUER': iduser
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

  Future<http.Response> uploadImage(String path, String name) async {
    final url =
        Uri.parse('https://api.seguridadsegser.com/api/acceso/uploadimagen');
    final imageuploadrequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file0', path);
    imageuploadrequest.headers['name'] = name;
    imageuploadrequest.files.add(file);

    final streamresponse = await imageuploadrequest.send();
    final resp = await http.Response.fromStream(streamresponse);
    //final responseString = await streamresponse.stream.bytesToString();
    //final result = jsonDecode(resp.body) as Map<String, dynamic>;
    return resp;
    //print (responseString.toString());
  }

  Future<http.Response> getvisits(int idclient) async {
    String _endpoint = "/api/acceso/getvisitabyidclient";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');

    int idcompany = await general().getidcompanyfromtoken();
    int iduser = await general().getiduserfromtoken();
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());

    final Map<String, dynamic> data = {
      'IDCOMPANY': idcompany,
      'IDCLIENT': idclient,
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

  Future<http.Response> darsalida(int id,String observacionsalida) async {
    String _endpoint = "/api/acceso/update";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');

    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());

    final Map<String, dynamic> data = {
      'ID': id,
      'FECHASALIDA': date,
      'HORASALIDA': time,
      'OBSERVACIONSALIDA':observacionsalida
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

  Future<http.Response> getdatacontratista(String id) async {
    String _endpoint = "/api/contratista/getbyid";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'ID': id,
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

  Future<http.Response> saveaccesworker() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());
    String _endpoint = "/api/accesotrabajadores/save";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'idcliente': idclient,
      'rut': rutctrl.text,
      'patente': patentectrl.text,
      'fecha_ingreso': date,
      'hora_ingreso': time,
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

  Future<http.Response> getoutworker(String id) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());
    String _endpoint = "/api/accesotrabajadores/salida";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'id': id,
      'fecha_salida': date,
      'hora_salida': time,
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

  Future<http.Response> getworkersaccesbydate() async {
    String _endpoint = "/api/accesotrabajadores/getworkersaccesbydate";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'idcliente': idclient,
      'fecha_ingreso': datectrl.text
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

  Future<http.Response> getworkersaccesbydatereport(
      String idclient, String fecha) async {
    String _endpoint = "/api/accesotrabajadores/getworkersaccesbydate";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');

    final Map<String, dynamic> data = {
      'idcliente': idclient,
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

  Future<http.Response> saveaccesocontratista(
      TrabajadorContratista trabajador) async {
    String _endpoint = "/api/accesocontratistas/save";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm:ss').format(DateTime.now());

    final Map<String, dynamic> data = {
      'id_contratista': trabajador.idContratista,
      'rut': trabajador.rut,
      'nombre': trabajador.nombre,
      'labor': trabajador.labor,
      'sexo': trabajador.sexo,
      'fecha_ingreso': date,
      'hora_ingreso': time
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

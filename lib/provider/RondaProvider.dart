import 'dart:convert';
import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rondines/response/guardResponse.dart';
import 'package:rondines/ui/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RondaProvider extends ChangeNotifier{
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  bool _isscanning=false;
  String IDCOMPANY='';
  int idzona=0;
  int idclient=0;
  int idcompany=0;
  int idpoint=0;
  String _imagepath='';
  String _cumple='Si';
  String Observacion='';
  double latitud=0.0;
  double longitud=0.0;
  String tipo='';
  String imagename='';

  bool _isloading=false;
  bool get isloading=>_isloading;

  set isloading(bool value){
    _isloading=value;
    notifyListeners();
  }


  int? idtipoguard=0;

  Position _position=Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  Position get position=>_position;

  
set position(Position value){
    _position=value;
    notifyListeners();
  }
  String get cumple=>_cumple;
  String get imagepath=>_imagepath;
  bool isValidateForm(){
    return formkey.currentState?.validate() ?? false;
  }
  set imagepath(String value){
    _imagepath=value;
    notifyListeners();
  }

  bool get isscanning=>_isscanning;
  
  set cumple(String value){
    _cumple=value;
    notifyListeners();
  }

  set isscanning (bool value){
    _isscanning=value;
    notifyListeners();
  }

  /* Future<http.Response>consultypeguards()async{
    
    
  } */
  Future<http.Response>gettipoguard()async{
    String _endpoint="/api/typeguard/gettypeguardsbycompany";

     final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     
     int idcompany=await general().getidcompanyfromtoken();
    final Map<String,dynamic> data={'IDCOMPANY':idcompany};
    String parametros=json.encode(data);  
    

    final url = Uri.https(general().baseUrl, _endpoint);
    
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";  
    header["Auth"] =  token!;  
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});
    
    return response;
  }

  Future<http.Response> uploadImage(String path,String name)async{

    final url=Uri.parse('https://api.seguridadsegser.com/api/guards/saveimage');
    final imageuploadrequest=http.MultipartRequest('POST',url);
    final file=await http.MultipartFile.fromPath('file0', path);
    imageuploadrequest.headers['name']=name;
    imageuploadrequest.files.add(file);


    final streamresponse=await imageuploadrequest.send();
    final resp=await http.Response.fromStream(streamresponse);
    //final responseString = await streamresponse.stream.bytesToString();
    //final result = jsonDecode(resp.body) as Map<String, dynamic>;
    return resp;
    //print (responseString.toString());
    
   }
  Future<http.Response>getnametag(String codenfc)async{
    String _endpoint="/api/point/searchbycode";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     
     int idcompany=await general().getidcompanyfromtoken();
    final Map<String,dynamic> data={'IDCOMPANY':idcompany,"CODE":codenfc};
    String parametros=json.encode(data);  
    

    final url = Uri.https(general().baseUrl, _endpoint);
    
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";  
    header["Auth"] =  token!;  
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});
    
    return response;

  }

    Future<http.Response>save(RondaProvider provider)async{
    String _endpoint="/api/guards/save";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     
     int usuario=await general().getiduserfromtoken();
     String date=DateFormat('yyyy-MM-dd').format(DateTime.now());
     String time=DateFormat('HH:mm:ss').format(DateTime.now());

     

    final Map<String,dynamic> data={'IDUSER':usuario,
                                    "IDTYPEGUAR":provider.idtipoguard,
                                    "DATE":date,
                                    "TIME":time,
                                    "IDPOINT":provider.idpoint,
                                    "LAT":provider.position.latitude,
                                    "LONG":provider.position.longitude,
                                    "OBSERVATION":provider.Observacion,
                                    "ISOK":provider.cumple=='Si' ? '1' : '0',
                                    "IDIMAGE":provider.imagename,
                                    "TYPEPOINT":provider.tipo,
                                    };
    String parametros=json.encode(data);  
    

    final url = Uri.https(general().baseUrl, _endpoint);
    
    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";  
    header["Auth"] =  token!;  
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});
    
    return response;

  }

  Future<http.Response>sync(Guard guard)async{
    String _endpoint="/api/guards/save";
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
    String nombrefoto=guard.date!.replaceAll("-", "")+guard.time!.replaceAll(":", "");

    final Map<String,dynamic> data={'IDUSER':guard.iduser,
      "IDTYPEGUAR":guard.idtypeguar,
      "DATE":guard.date,
      "TIME":guard.time,
      "IDPOINT":guard.idpoint,
      "LAT":guard.lat,
      "LONG":guard.longi,
      "OBSERVATION":guard.observacion,
      "ISOK":guard.isok,
      "IDIMAGE":nombrefoto,
      "TYPEPOINT":guard.typepoint,
    };
    String parametros=json.encode(data);


    final url = Uri.https(general().baseUrl, _endpoint);

    Map<String, String> header = new Map();
    header["content-type"] =  "application/x-www-form-urlencoded";
    header["Auth"] =  token!;
    final response = await http.post(url, body: {"json":parametros},headers: {"Auth": token!});

    return response;

  }

}


  /* jsonObject.put("IDUSER",usuario);
            jsonObject.put("IDTYPEGUAR",tipoguardia);
            jsonObject.put("DATE",fecha);
            jsonObject.put("TIME",hora);
            jsonObject.put("IDPOINT",idpoint);
            jsonObject.put("LAT",latitud);
            jsonObject.put("LONG",longitud);
            jsonObject.put("OBSERVATION",observacion);
            jsonObject.put("ISOK",isok);
            jsonObject.put("IDIMAGE",nombrefoto);
            jsonObject.put("TYPEPOINT",tipo); 
            
              SimpleDateFormat ho=new SimpleDateFormat("HH:mm:ss");
        String hora=ho.format(new Date());
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); //dd/MM/yyyy HH:mm:

                 String url= Global.url+"guards/save";

            */
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class general{

   String baseUrl = "api.seguridadsegser.com";  
    Future<bool> isOnlineNet() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
  }
   Future<String>gettoken()async{
     final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
     final SharedPreferences prefs = await _prefs;
     return await prefs.getString('token') ?? '';
   }
  Future<int>getiduserfromtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return await decodedToken["IDUSER"]!;
    
    
  }
  Future<int>getidcompanyfromtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
     
    return await decodedToken["IDCOMPANY"]!;
    
    
  }
  Future<int>getidrolefromtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
     
    return await decodedToken["IDROLE"]!;
    
    
  }
  Future<int>getidclientfromtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
     
    return await decodedToken["IDCLIENT"]!;
    
    
  }
  Future<String>getnamefromtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken["NAME"]!;
    
    
  }
  Future<String>getusername()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken["USERNAME"]!;
    
    
  }



  Future<DateTime>getdateofexpiredtoken()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
     DateTime expirationDate = JwtDecoder.getExpirationDate(token!);
    return expirationDate;
  }

  Future<int>istokenexpired()async{
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final String? token=prefs.getString('token');
      
    bool isTokenExpired = JwtDecoder.isExpired(token!);
    int vencido=0;
    isTokenExpired ? vencido=1 : vencido=0;
    return vencido;
  }

}
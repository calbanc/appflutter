
import 'package:flutter/material.dart';

class NotificationsService {


  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();


  static showSnackbar( String message ) {

     final snackBar = new SnackBar(
      content: Text( message, style: TextStyle( color: Colors.white, fontSize: 15) ),
      backgroundColor: Colors.red,
      elevation: 20 ,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(40),
    ); 

    messengerKey.currentState!.showSnackBar(snackBar);
   
  }
}
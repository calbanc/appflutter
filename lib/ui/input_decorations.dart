import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration authInputDecoration({
    required String hintext,
    required String labeltext,
    IconData? icono,
  }){

    return InputDecoration(
       enabledBorder:UnderlineInputBorder(
        borderSide: BorderSide(
          color:Color.fromARGB(255, 76, 76, 76)
          ), 
      ),
      focusedBorder:UnderlineInputBorder(
        borderSide: BorderSide(
          color:Colors.black38,
          width: 2
        )
      ), 
      hintText:hintext,
      labelText:labeltext,
      labelStyle:TextStyle(
        color:Colors.black38
      ),
      prefixIcon:icono!=null ? Icon(icono,color:Colors.black) : null
       
    );
  }

 

}

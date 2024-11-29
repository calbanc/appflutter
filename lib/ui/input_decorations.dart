import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration authInputDecoration({
    required String hintext,
    required String labeltext,
    IconData? icono,
    IconButton? sufixiconobutton,
  }){

    return InputDecoration(
       enabledBorder:OutlineInputBorder(
        borderSide: BorderSide(
          color:Color.fromARGB(255, 76, 76, 76)
          ), 
      ),
      border:OutlineInputBorder(
        borderSide: BorderSide(
          color:Colors.black38,
          width: 1
        )
      ), 
      hintText:hintext,
      labelText:labeltext,
      labelStyle:TextStyle(
        color:Colors.black38
      ),

      suffixIcon: sufixiconobutton!=null ? sufixiconobutton : null,
       
    );
  }

 

}

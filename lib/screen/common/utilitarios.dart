import 'package:flutter/material.dart';
import 'package:rondines/screen/common/ScanQrScreen.dart';

class Utilitarios {

Future<String> scanqr(BuildContext context) async {
    String resultado = "";

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true, // esto lo presenta como modal
        builder: (context) => ScanQrScreen(),
      ),
    );

    if (result != null) {
      resultado = result;
    }

    return resultado;
  }

}
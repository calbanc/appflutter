// To parse this JSON data, do
//
//     final trabajadorResponse = trabajadorResponseFromMap(jsonString);

import 'dart:convert';

TrabajadorResponse trabajadorResponseFromMap(String str) =>
    TrabajadorResponse.fromMap(json.decode(str));

String trabajadorResponseToMap(TrabajadorResponse data) =>
    json.encode(data.toMap());

class TrabajadorResponse {
  String? status;
  int? code;
  List<Trabajdore>? trabajdores;
  List<Acceso>? acceso;

  TrabajadorResponse({
    this.status,
    this.code,
    this.trabajdores,
    this.acceso,
  });

  factory TrabajadorResponse.fromMap(Map<String, dynamic> json) =>
      TrabajadorResponse(
        status: json["status"],
        code: json["code"],
        trabajdores: json["trabajdores"] == null
            ? []
            : List<Trabajdore>.from(
                json["trabajdores"]!.map((x) => Trabajdore.fromMap(x))),
        acceso: json["acceso"] == null
            ? []
            : List<Acceso>.from(json["acceso"]!.map((x) => Acceso.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "trabajdores": trabajdores == null
            ? []
            : List<dynamic>.from(trabajdores!.map((x) => x.toMap())),
        "acceso": acceso == null
            ? []
            : List<dynamic>.from(acceso!.map((x) => x.toMap())),
      };
}

class Acceso {
  int? id;
  int? idcliente;
  String? rut;
  String? fechaIngreso;
  String? horaIngreso;
  dynamic fechaSalida;
  dynamic horaSalida;
  int? userId;

  Acceso({
    this.id,
    this.idcliente,
    this.rut,
    this.fechaIngreso,
    this.horaIngreso,
    this.fechaSalida,
    this.horaSalida,
    this.userId,
  });

  factory Acceso.fromMap(Map<String, dynamic> json) => Acceso(
        id: json["id"],
        idcliente: json["idcliente"],
        rut: json["rut"],
        fechaIngreso:
            json["fecha_ingreso"] == null ? null : json["fecha_ingreso"],
        horaIngreso: json["hora_ingreso"],
        fechaSalida: json["fecha_salida"],
        horaSalida: json["hora_salida"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "idcliente": idcliente,
        "rut": rut,
        "fecha_ingreso": fechaIngreso,
        "hora_ingreso": horaIngreso,
        "fecha_salida": fechaSalida,
        "hora_salida": horaSalida,
        "user_id": userId,
      };
}

class Trabajdore {
  int? idcliente;
  String? rut;
  String? apellidopaterno;
  String? apellidomaterno;
  String? nombres;
  String? cargo;
  String? area;
  String? nfc;
  String? qr;

  Trabajdore({
    this.idcliente,
    this.rut,
    this.apellidopaterno,
    this.apellidomaterno,
    this.nombres,
    this.cargo,
    this.area,
    this.nfc,
    this.qr,
  });

  factory Trabajdore.fromMap(Map<String, dynamic> json) => Trabajdore(
        idcliente: json["idcliente"],
        rut: json["rut"],
        apellidopaterno: json["apellidopaterno"],
        apellidomaterno: json["apellidomaterno"],
        nombres: json["nombres"],
        cargo: json["cargo"],
        area: json["area"],
        nfc: json["nfc"],
        qr: json["qr"],
      );

  Map<String, dynamic> toMap() => {
        "idcliente": idcliente,
        "rut": rut,
        "apellidopaterno": apellidopaterno,
        "apellidomaterno": apellidomaterno,
        "nombres": nombres,
        "cargo": cargo,
        "area": area,
        "nfc": nfc,
        "qr": qr,
      };
}

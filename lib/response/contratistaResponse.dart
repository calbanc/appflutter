// To parse this JSON data, do
//
//     final contratistaResponse = contratistaResponseFromMap(jsonString);

import 'dart:convert';

ContratistaResponse contratistaResponseFromMap(String str) => ContratistaResponse.fromMap(json.decode(str));

String contratistaResponseToMap(ContratistaResponse data) => json.encode(data.toMap());

class ContratistaResponse {
  String? status;
  int? code;
  List<Contratista>? contratista;
  String? xls;

  ContratistaResponse({
    this.status,
    this.code,
    this.contratista,
    this.xls,
  });

  factory ContratistaResponse.fromMap(Map<String, dynamic> json) => ContratistaResponse(
    status: json["status"],
    code: json["code"],
    contratista: json["contratista"] == null ? [] : List<Contratista>.from(json["contratista"]!.map((x) => Contratista.fromMap(x))),
    xls: json["xls"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "code": code,
    "contratista": contratista == null ? [] : List<dynamic>.from(contratista!.map((x) => x.toMap())),
    "xls": xls,
  };
}

class Contratista {
  int? id;
  int? idcompany;
  int? idclient;
  String? rut;
  String? nombreConductor;
  String? patente;
  String? fechaInicio;
  String? fechaTermino;
  String? idarchivo;


  Contratista({
    this.id,
    this.idcompany,
    this.idclient,
    this.rut,
    this.nombreConductor,
    this.patente,
    this.fechaInicio,
    this.fechaTermino,
    this.idarchivo,

  });

  factory Contratista.fromMap(Map<String, dynamic> json) => Contratista(
    id: json["id"],
    idcompany: json["idcompany"],
    idclient: json["idclient"],
    rut: json["rut"],
    nombreConductor: json["nombre_conductor"],
    patente: json["patente"],
    fechaInicio: json["fecha_inicio"] ,
    fechaTermino: json["fecha_termino"] ,
    idarchivo: json["idarchivo"],

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "idcompany": idcompany,
    "idclient": idclient,
    "rut": rut,
    "nombre_conductor": nombreConductor,
    "patente": patente,
    "fecha_inicio": fechaInicio,
    "fecha_termino": fechaTermino,
    "idarchivo": idarchivo,

  };
}

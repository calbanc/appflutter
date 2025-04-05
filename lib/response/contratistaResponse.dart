// To parse this JSON data, do
//
//     final contratistaResponse = contratistaResponseFromMap(jsonString);

import 'dart:convert';

ContratistaResponse contratistaResponseFromMap(String str) =>
    ContratistaResponse.fromMap(json.decode(str));

String contratistaResponseToMap(ContratistaResponse data) =>
    json.encode(data.toMap());

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

  factory ContratistaResponse.fromMap(Map<String, dynamic> json) =>
      ContratistaResponse(
        status: json["status"],
        code: json["code"],
        contratista: json["contratista"] == null
            ? []
            : List<Contratista>.from(
                json["contratista"]!.map((x) => Contratista.fromMap(x))),
        xls: json["xls"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "contratista": contratista == null
            ? []
            : List<dynamic>.from(contratista!.map((x) => x.toMap())),
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
  String? rutContratista;
  String? nombreContratista;

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
    this.rutContratista,
    this.nombreContratista,
  });

  factory Contratista.fromMap(Map<String, dynamic> json) => Contratista(
        id: json["id"],
        idcompany: json["idcompany"],
        idclient: json["idclient"],
        rut: json["rut"],
        nombreConductor: json["nombre_conductor"],
        patente: json["patente"],
        fechaInicio: json["fecha_inicio"],
        fechaTermino: json["fecha_termino"],
        idarchivo: json["idarchivo"],
        rutContratista: json["rutcontratista"],
        nombreContratista: json["nombre_contratista"],
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
        "rutcontratista": rutContratista,
        "nombre_contratista": nombreContratista,
      };
}

class TrabajadorContratista {
  int? idContratista;

  String? rut;
  String? nombre;
  String? labor;
  String? sexo;
  String? fechaIngreso;
  String? horaIngreso;

  TrabajadorContratista({
    this.idContratista,
    this.rut,
    this.nombre,
    this.labor,
    this.sexo,
    this.fechaIngreso,
    this.horaIngreso,
  });

  factory TrabajadorContratista.fromMap(Map<String, dynamic> json) =>
      TrabajadorContratista(
        idContratista: json["id_contratista"],
        rut: json["rut"],
        nombre: json["nombre"],
        labor: json["labor"],
        sexo: json["sexo"],
        fechaIngreso: json["fecha_ingreso"],
        horaIngreso: json["hora_ingreso"],
      );

  Map<String, dynamic> toMap() => {
        "id_contratista": idContratista,
        "rut": rut,
        "nombre": nombre,
        "labor": labor,
        "sexo": sexo,
        "fecha_ingreso": fechaIngreso,
        "hora_ingreso": horaIngreso,
      };
}

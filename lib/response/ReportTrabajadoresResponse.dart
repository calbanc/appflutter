// To parse this JSON data, do
//
//     final reportTrabajadoresResponse = reportTrabajadoresResponseFromMap(jsonString);

import 'dart:convert';

ReportTrabajadoresResponse reportTrabajadoresResponseFromMap(String str) => ReportTrabajadoresResponse.fromMap(json.decode(str));

String reportTrabajadoresResponseToMap(ReportTrabajadoresResponse data) => json.encode(data.toMap());

class ReportTrabajadoresResponse {
  String? status;
  int? code;
  List<Listacceso>? listaccesos;

  ReportTrabajadoresResponse({
    this.status,
    this.code,
    this.listaccesos,
  });

  factory ReportTrabajadoresResponse.fromMap(Map<String, dynamic> json) => ReportTrabajadoresResponse(
    status: json["status"],
    code: json["code"],
    listaccesos: json["listaccesos"] == null ? [] : List<Listacceso>.from(json["listaccesos"]!.map((x) => Listacceso.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "code": code,
    "listaccesos": listaccesos == null ? [] : List<dynamic>.from(listaccesos!.map((x) => x.toMap())),
  };
}

class Listacceso {
  int? id;
  int? idcliente;
  String? rut;
  String? fechaIngreso;
  String? horaIngreso;
  String? patente;
  String? fechaSalida;
  String? horaSalida;
  int? userId;
  String? nombres;
  String? apellidopaterno;
  String? apellidomaterno;
  String? name;
  String? lastname;

  Listacceso({
    this.id,
    this.idcliente,
    this.rut,
    this.fechaIngreso,
    this.horaIngreso,
    this.patente,
    this.fechaSalida,
    this.horaSalida,
    this.userId,
    this.nombres,
    this.apellidopaterno,
    this.apellidomaterno,
    this.name,
    this.lastname,
  });

  factory Listacceso.fromMap(Map<String, dynamic> json) => Listacceso(
    id: json["id"],
    idcliente: json["idcliente"],
    rut: json["rut"],
    fechaIngreso: json["fecha_ingreso"] == null ? null : json["fecha_ingreso"],
    horaIngreso: json["hora_ingreso"],
    patente: json["patente"],
    fechaSalida: json["fecha_salida"] == null ? null : json["fecha_salida"],
    horaSalida: json["hora_salida"],
    userId: json["user_id"],
    nombres: json["nombres"],
    apellidopaterno: json["apellidopaterno"],
    apellidomaterno: json["apellidomaterno"],
    name: json["NAME"],
    lastname: json["LASTNAME"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "idcliente": idcliente,
    "rut": rut,
    "fecha_ingreso": fechaIngreso,
    "hora_ingreso": horaIngreso,
    "patente": patente,
    "fecha_salida":fechaSalida,
    "hora_salida": horaSalida,
    "user_id": userId,
    "nombres": nombres,
    "apellidopaterno": apellidopaterno,
    "apellidomaterno": apellidomaterno,
    "NAME": name,
    "LASTNAME": lastname,
  };
}

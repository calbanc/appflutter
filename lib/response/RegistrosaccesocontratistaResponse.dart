// To parse this JSON data, do
//
//     final registrosaccesocontratistaResponse = registrosaccesocontratistaResponseFromJson(jsonString);

import 'dart:convert';

RegistrosaccesocontratistaResponse registrosaccesocontratistaResponseFromJson(
        String str) =>
    RegistrosaccesocontratistaResponse.fromJson(json.decode(str));

String registrosaccesocontratistaResponseToJson(
        RegistrosaccesocontratistaResponse data) =>
    json.encode(data.toJson());

class RegistrosaccesocontratistaResponse {
  String? status;
  int? code;
  String? message;
  List<Accesocontratista>? accesocontratista;

  RegistrosaccesocontratistaResponse({
    this.status,
    this.code,
    this.message,
    this.accesocontratista,
  });

  factory RegistrosaccesocontratistaResponse.fromJson(
          Map<String, dynamic> json) =>
      RegistrosaccesocontratistaResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        accesocontratista: json["accesocontratista"] == null
            ? []
            : List<Accesocontratista>.from(json["accesocontratista"]!
                .map((x) => Accesocontratista.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "accesocontratista": accesocontratista == null
            ? []
            : List<dynamic>.from(accesocontratista!.map((x) => x.toJson())),
      };
}

class Accesocontratista {
  int? id;
  int? idContratista;
  String? rut;
  String? nombre;
  String? labor;
  String? sexo;
  DateTime? fechaIngreso;
  String? horaIngreso;
  dynamic fechaSalida;
  dynamic horaSalida;
  int? idcompany;
  int? idclient;
  String? nombreConductor;
  String? patente;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  String? idarchivo;

  Accesocontratista({
    this.id,
    this.idContratista,
    this.rut,
    this.nombre,
    this.labor,
    this.sexo,
    this.fechaIngreso,
    this.horaIngreso,
    this.fechaSalida,
    this.horaSalida,
    this.idcompany,
    this.idclient,
    this.nombreConductor,
    this.patente,
    this.fechaInicio,
    this.fechaTermino,
    this.idarchivo,
  });

  factory Accesocontratista.fromJson(Map<String, dynamic> json) =>
      Accesocontratista(
        id: json["id"],
        idContratista: json["id_contratista"],
        rut: json["rut"],
        nombre: json["nombre"],
        labor: json["labor"],
        sexo: json["sexo"],
        fechaIngreso: json["fecha_ingreso"] == null
            ? null
            : DateTime.parse(json["fecha_ingreso"]),
        horaIngreso: json["hora_ingreso"],
        fechaSalida: json["fecha_salida"],
        horaSalida: json["hora_salida"],
        idcompany: json["idcompany"],
        idclient: json["idclient"],
        nombreConductor: json["nombre_conductor"],
        patente: json["patente"],
        fechaInicio: json["fecha_inicio"] == null
            ? null
            : DateTime.parse(json["fecha_inicio"]),
        fechaTermino: json["fecha_termino"] == null
            ? null
            : DateTime.parse(json["fecha_termino"]),
        idarchivo: json["idarchivo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_contratista": idContratista,
        "rut": rut,
        "nombre": nombre,
        "labor": labor,
        "sexo": sexo,
        "fecha_ingreso":
            "${fechaIngreso!.year.toString().padLeft(4, '0')}-${fechaIngreso!.month.toString().padLeft(2, '0')}-${fechaIngreso!.day.toString().padLeft(2, '0')}",
        "hora_ingreso": horaIngreso,
        "fecha_salida": fechaSalida,
        "hora_salida": horaSalida,
        "idcompany": idcompany,
        "idclient": idclient,
        "nombre_conductor": nombreConductor,
        "patente": patente,
        "fecha_inicio":
            "${fechaInicio!.year.toString().padLeft(4, '0')}-${fechaInicio!.month.toString().padLeft(2, '0')}-${fechaInicio!.day.toString().padLeft(2, '0')}",
        "fecha_termino":
            "${fechaTermino!.year.toString().padLeft(4, '0')}-${fechaTermino!.month.toString().padLeft(2, '0')}-${fechaTermino!.day.toString().padLeft(2, '0')}",
        "idarchivo": idarchivo,
      };
}

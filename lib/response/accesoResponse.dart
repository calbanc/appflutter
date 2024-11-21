// To parse this JSON data, do
//
//     final accesoResponse = accesoResponseFromMap(jsonString);

import 'dart:convert';

AccesoResponse accesoResponseFromMap(String str) =>
    AccesoResponse.fromMap(json.decode(str));

String accesoResponseToMap(AccesoResponse data) => json.encode(data.toMap());

class AccesoResponse {
  String? status;
  int? code;
  List<Listacceso>? listaccesos;

  AccesoResponse({
    this.status,
    this.code,
    this.listaccesos,
  });

  factory AccesoResponse.fromMap(Map<String, dynamic> json) => AccesoResponse(
        status: json["status"],
        code: json["code"],
        listaccesos: json["listaccesos"] == null
            ? []
            : List<Listacceso>.from(
                json["listaccesos"]!.map((x) => Listacceso.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "listaccesos": listaccesos == null
            ? []
            : List<dynamic>.from(listaccesos!.map((x) => x.toMap())),
      };
}

class Listacceso {
  int? id;
  int? idcliente;
  String? rut;
  DateTime? fechaIngreso;
  String? horaIngreso;
  DateTime? fechaSalida;
  String? horaSalida;
  int? userId;
  String? nombres;
  String? apellidopaterno;
  String? apellidomaterno;
  String? name;
  String? lastname;
  String? patente;

  Listacceso({
    this.id,
    this.idcliente,
    this.rut,
    this.fechaIngreso,
    this.horaIngreso,
    this.fechaSalida,
    this.horaSalida,
    this.userId,
    this.nombres,
    this.apellidopaterno,
    this.apellidomaterno,
    this.name,
    this.lastname,
    this.patente
  });

  factory Listacceso.fromMap(Map<String, dynamic> json) => Listacceso(
        id: json["id"],
        idcliente: json["idcliente"],
        rut: json["rut"],
        fechaIngreso: json["fecha_ingreso"] == null
            ? null
            : DateTime.parse(json["fecha_ingreso"]),
        horaIngreso: json["hora_ingreso"],
        fechaSalida: json["fecha_salida"] == null
            ? null
            : DateTime.parse(json["fecha_salida"]),

        patente: json["patente"] == null
        ? null
        : json["patente"],
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
        "fecha_ingreso":
            "${fechaIngreso!.year.toString().padLeft(4, '0')}-${fechaIngreso!.month.toString().padLeft(2, '0')}-${fechaIngreso!.day.toString().padLeft(2, '0')}",
        "hora_ingreso": horaIngreso,
        "fecha_salida":
            "${fechaSalida!.year.toString().padLeft(4, '0')}-${fechaSalida!.month.toString().padLeft(2, '0')}-${fechaSalida!.day.toString().padLeft(2, '0')}",
        "hora_salida": horaSalida,
        "user_id": userId,
        "nombres": nombres,
        "apellidopaterno": apellidopaterno,
        "apellidomaterno": apellidomaterno,
        "NAME": name,
        "LASTNAME": lastname,
      };
}

import 'dart:convert';

import 'package:rondines/response/ZonebyClientResponse.dart';

class VisitByclientResponse {
    String? status;
    int? code;
    String? message;
    List<Visit>? data;

    VisitByclientResponse({
        this.status,
        this.code,
        this.message,
        this.data,
    });

    factory VisitByclientResponse.fromJson(String str) => VisitByclientResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory VisitByclientResponse.fromMap(Map<String, dynamic> json) => VisitByclientResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Visit>.from(json["data"]!.map((x) => Visit.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Visit {
    int? idcompany;
    int? idclient;
    int? idzon;
    String? rutvisita;
    String? nombrevisita;
    String? motivovisita;
    String? patentevehiculo;
    DateTime? fechaingreso;
    String? horaingreso;
    dynamic fechasalida;
    dynamic horasalida;
    int? id;
    int? iduser;
    dynamic patentecarro;
    String? ingresoproducto;
    String? retiroproducto;
    String? nroguia;
    String? nrofactura;
    String? idfotoguia;
    String? idfotofactura;
    String? idfotoproducto;
    Zona? zona;

    Visit({
        this.idcompany,
        this.idclient,
        this.idzon,
        this.rutvisita,
        this.nombrevisita,
        this.motivovisita,
        this.patentevehiculo,
        this.fechaingreso,
        this.horaingreso,
        this.fechasalida,
        this.horasalida,
        this.id,
        this.iduser,
        this.patentecarro,
        this.ingresoproducto,
        this.retiroproducto,
        this.nroguia,
        this.nrofactura,
        this.idfotoguia,
        this.idfotofactura,
        this.idfotoproducto,
        this.zona,
    });

    factory Visit.fromJson(String str) => Visit.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Visit.fromMap(Map<String, dynamic> json) => Visit(
        idcompany: json["IDCOMPANY"],
        idclient: json["IDCLIENT"],
        idzon: json["IDZON"],
        rutvisita: json["RUTVISITA"],
        nombrevisita: json["NOMBREVISITA"],
        motivovisita: json["MOTIVOVISITA"],
        patentevehiculo: json["PATENTEVEHICULO"],
        fechaingreso: json["FECHAINGRESO"] == null ? null : DateTime.parse(json["FECHAINGRESO"]),
        horaingreso: json["HORAINGRESO"],
        fechasalida: json["FECHASALIDA"],
        horasalida: json["HORASALIDA"],
        id: json["ID"],
        iduser: json["IDUSER"],
        patentecarro: json["PATENTECARRO"],
        ingresoproducto: json["INGRESOPRODUCTO"],
        retiroproducto: json["RETIROPRODUCTO"],
        nroguia: json["NROGUIA"],
        nrofactura: json["NROFACTURA"],
        idfotoguia: json["IDFOTOGUIA"],
        idfotofactura: json["IDFOTOFACTURA"],
        idfotoproducto: json["IDFOTOPRODUCTO"],
        zona: json["zona"] == null ? null : Zona.fromMap(json["zona"]),
    );

    Map<String, dynamic> toMap() => {
        "IDCOMPANY": idcompany,
        "IDCLIENT": idclient,
        "IDZON": idzon,
        "RUTVISITA": rutvisita,
        "NOMBREVISITA": nombrevisita,
        "MOTIVOVISITA": motivovisita,
        "PATENTEVEHICULO": patentevehiculo,
        "FECHAINGRESO": "${fechaingreso!.year.toString().padLeft(4, '0')}-${fechaingreso!.month.toString().padLeft(2, '0')}-${fechaingreso!.day.toString().padLeft(2, '0')}",
        "HORAINGRESO": horaingreso,
        "FECHASALIDA": fechasalida,
        "HORASALIDA": horasalida,
        "ID": id,
        "IDUSER": iduser,
        "PATENTECARRO": patentecarro,
        "INGRESOPRODUCTO": ingresoproducto,
        "RETIROPRODUCTO": retiroproducto,
        "NROGUIA": nroguia,
        "NROFACTURA": nrofactura,
        "IDFOTOGUIA": idfotoguia,
        "IDFOTOFACTURA": idfotofactura,
        "IDFOTOPRODUCTO": idfotoproducto,
        "zona": zona?.toMap(),
    };
}

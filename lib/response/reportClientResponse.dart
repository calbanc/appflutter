import 'dart:convert';

class ReportClientResponse {
    String? status;
    String? code;
    List<Report>? data;

    ReportClientResponse({
        this.status,
        this.code,
        this.data,
    });

    factory ReportClientResponse.fromJson(String str) => ReportClientResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReportClientResponse.fromMap(Map<String, dynamic> json) => ReportClientResponse(
        status: json["status"],
        code: json["code"],
        data: json["data"] == null ? [] : List<Report>.from(json["data"]!.map((x) => Report.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Report {
    int? id;
    DateTime? date;
    String? time;
    double? lat;
    double? long;
    String? observation;
    String? typepoint;
    String? isok;
    String? idimage;
    String? puntocontrol;
    String? n0Mbrecliente;
    String? zona;
    String? companiadeseguridad;
    String? typeguardia;
    String? rondin;
    String? validado;

    
    Report({
        this.id,
        this.date,
        this.time,
        this.lat,
        this.long,
        this.observation,
        this.typepoint,
        this.isok,
        this.idimage,
        this.puntocontrol,
        this.n0Mbrecliente,
        this.zona,
        this.companiadeseguridad,
        this.typeguardia,
        this.rondin,
        this.validado,
    });

    factory Report.fromJson(String str) => Report.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Report.fromMap(Map<String, dynamic> json) => Report(
        id: json["ID"],
        date: json["DATE"] == null ? null : DateTime.parse(json["DATE"]),
        time: json["TIME"],
        lat: json["LAT"]?.toDouble(),
        long: json["LONG"]?.toDouble(),
        observation: json["OBSERVATION"],
        typepoint: json["TYPEPOINT"],
        isok: json["ISOK"],
        idimage: json["IDIMAGE"],
        puntocontrol: json["PUNTOCONTROL"],
        n0Mbrecliente: json["N0MBRECLIENTE"],
        zona: json["ZONA"],
        companiadeseguridad: json["COMPANIADESEGURIDAD"],
        typeguardia: json["TYPEGUARDIA"],
        rondin: json["RONDIN"],
        validado: json["VALIDADO"],
    );

    Map<String, dynamic> toMap() => {
        "ID": id,
        "DATE": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "TIME": time,
        "LAT": lat,
        "LONG": long,
        "OBSERVATION": observation,
        "TYPEPOINT": typepoint,
        "ISOK": isok,
        "IDIMAGE": idimage,
        "PUNTOCONTROL": puntocontrol,
        "N0MBRECLIENTE": n0Mbrecliente,
        "ZONA": zona,
        "COMPANIADESEGURIDAD": companiadeseguridad,
        "TYPEGUARDIA": typeguardia,
        "RONDIN": rondin,
        "VALIDADO": validado,
    };
}

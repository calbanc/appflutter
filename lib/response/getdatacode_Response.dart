import 'dart:convert';

class GetdatacodeResponse {
    String? status;
    int? code;
    List<Point>? point;

    GetdatacodeResponse({
        this.status,
        this.code,
        this.point,
    });

    factory GetdatacodeResponse.fromJson(String str) => GetdatacodeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetdatacodeResponse.fromMap(Map<String, dynamic> json) => GetdatacodeResponse(
        status: json["status"],
        code: json["code"],
        point: json["data"] == null ? [] : List<Point>.from(json["data"]!.map((x) => Point.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "data": point == null ? [] : List<dynamic>.from(point!.map((x) => x.toJson())),
    };
}

class Point {
    int? id;
    int? idcompany;
    int? idclient;
    String? name;
    int? lat;
    int? longi;
    String? code;
    int? idzone;
    int? iscriadero;


    Point({
        this.id,
        this.idcompany,
        this.idclient,
        this.name,
        this.lat,
        this.longi,
        this.code,
        this.idzone,
        this.iscriadero,

    });



    factory Point.fromJson(Map<String, dynamic> json) => Point(
        id: json["ID"],
        idcompany: json["IDCOMPANY"],
        idclient: json["IDCLIENT"],
        name: json["NAME"],
        lat: json["LAT"],
        longi: json["LONGI"],
        code: json["CODE"],
        idzone: json["IDZONE"],
        iscriadero: json["ISCRIADERO"],

    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "IDCOMPANY": idcompany,
        "IDCLIENT": idclient,
        "NAME": name,
        "LAT": lat,
        "LONGI": longi,
        "CODE": code,
        "IDZONE": idzone,
        "ISCRIADERO": iscriadero,

    };



}

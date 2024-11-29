import 'dart:convert';

class GuardResponse {
    String? status;
    String? code;
    List<Guard>? guard;

    GuardResponse({
        this.status,
        this.code,
        this.guard,
    });

    factory GuardResponse.fromJson(String str) => GuardResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GuardResponse.fromMap(Map<String, dynamic> json) => GuardResponse(
        status: json["status"],
        code: json["code"],
        guard: json["guard"] == null ? [] : List<Guard>.from(json["guard"]!.map((x) => Guard.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "guard": guard == null ? [] : List<dynamic>.from(guard!.map((x) => x.toMap())),
    };
}

class Guard {
    int? id;
    int? iduser;
    int? idtypeguar;
    String? date;
    String? time;
    String? lat;
    String? longi;
    int? idpoint;
    String? observacion;
    String? isok;
    String? idimage;
    String? typepoint;
    String? punto;
    String? tipo;
    String? sw_enviado;

    
    Guard({
        this.id,
        this.iduser,
        this.idtypeguar,
        this.date,
        this.time,
        this.lat,
        this.longi,
        this.idpoint,
        this.observacion,
        this.isok,
        this.idimage,
        this.typepoint,
        this.punto,
        this.tipo,

        this.sw_enviado
        
    });

    factory Guard.fromJson(String str) => Guard.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Guard.fromMap(Map<String, dynamic> json) => Guard(
        id:json["ID"],
        iduser: json["IDUSER"],
        idtypeguar:json["IDTYPEGUAR"],
        date: json["DATE"],
        time: json["TIME"],
        lat: json["LAT"],
        longi: json["LONGI"],
        idpoint: json["IDPOINT"],
        observacion: json["OBSERVACION"],
        isok: json["ISOK"],
        idimage: json["IDIMAGE"],
        typepoint: json["TYPEPOINT"],
        tipo:json["TIPO"],
        punto: json["PUNTO"],

        sw_enviado: json["SW_ENVIADO"]
        
        
    );

    Map<String, dynamic> toMap() => {
        "ID":id,
        "IDUSER": iduser,
        "IDTYPEGUAR":idtypeguar,
        "DATE":date,
        "TIME": time,
        "LAT": lat,
        "LONGI": longi,
        "IDPOINT": idpoint,
        "OBSERVACION": observacion,
        "ISOK": isok,
        "IDIMAGE": idimage,
        "TYPEPOINT": typepoint,
        "SW_ENVIADO":sw_enviado
    };
}
 
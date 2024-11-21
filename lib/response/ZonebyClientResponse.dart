import 'dart:convert';

class ZonebyClientResponse {
    String? status;
    int? code;
    List<Zona>? data;

    ZonebyClientResponse({
        this.status,
        this.code,
        this.data,
    });

    factory ZonebyClientResponse.fromJson(String str) => ZonebyClientResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ZonebyClientResponse.fromMap(Map<String, dynamic> json) => ZonebyClientResponse(
        status: json["status"],
        code: json["code"],
        data: json["data"] == null ? [] : List<Zona>.from(json["data"]!.map((x) => Zona.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Zona {
    int? id;
    int? idclient;
    String? name;
    int? idcompany;
    Clients? clients;

    Zona({
        this.id,
        this.idclient,
        this.name,
        this.idcompany,
        this.clients,
    });

    factory Zona.fromJson(String str) => Zona.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Zona.fromMap(Map<String, dynamic> json) => Zona(
        id: json["ID"],
        idclient: json["IDCLIENT"],
        name: json["NAME"],
        idcompany: json["IDCOMPANY"],
        clients: json["clients"] == null ? null : Clients.fromMap(json["clients"]),
    );

    Map<String, dynamic> toMap() => {
        "ID": id,
        "IDCLIENT": idclient,
        "NAME": name,
        "IDCOMPANY": idcompany,
        "clients": clients?.toMap(),
    };
}

class Clients {
    int? id;
    String? name;
    String? addres;
    String? country;
    String? dateinit;
    int? idcompany;
    String? email;

    Clients({
        this.id,
        this.name,
        this.addres,
        this.country,
        this.dateinit,
        this.idcompany,
        this.email,
    });

    factory Clients.fromJson(String str) => Clients.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Clients.fromMap(Map<String, dynamic> json) => Clients(
        id: json["ID"],
        name: json["NAME"],
        addres: json["ADDRES"],
        country: json["COUNTRY"],
        dateinit: json["DATEINIT"],
        idcompany: json["IDCOMPANY"],
        email: json["EMAIL"],
    );

    Map<String, dynamic> toMap() => {
        "ID": id,
        "NAME": name,
        "ADDRES": addres,
        "COUNTRY": country,
        "DATEINIT": dateinit,
        "IDCOMPANY": idcompany,
        "EMAIL": email,
    };
}

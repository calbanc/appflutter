// To parse this JSON data, do
//
//     final gettypeguardsbycompanyResponse = gettypeguardsbycompanyResponseFromJson(jsonString);

import 'dart:convert';


class GettypeguardsbycompanyResponse {
    String? status;
    int? code;
    List<TipoGuard>? tipoguard;

    GettypeguardsbycompanyResponse({
        this.status,
        this.code,
        this.tipoguard,
    });

    factory GettypeguardsbycompanyResponse.fromJson(String str) => GettypeguardsbycompanyResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());


    factory GettypeguardsbycompanyResponse.fromMap(Map<String, dynamic> json) => GettypeguardsbycompanyResponse(
        status: json["status"],
        code: json["code"],
        tipoguard: json["data"] == null ? [] : List<TipoGuard>.from(json["data"]!.map((x) => TipoGuard.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "data": tipoguard == null ? [] : List<dynamic>.from(tipoguard!.map((x) => x.toJson())),
    };
}

class TipoGuard {
    int? id;
    int? idcompany;
    String? name;

    TipoGuard({
        this.id,
        this.idcompany,
        this.name,
    });

    factory TipoGuard.fromJson(Map<String, dynamic> json) => TipoGuard(
        id: json["ID"],
        idcompany: json["IDCOMPANY"],
        name: json["NAME"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "IDCOMPANY": idcompany,
        "NAME": name,
    };
}

import 'dart:convert';

class ClientsbyCompanyResponse {
    String status;
    int code;
    List<Client> clientes;

    ClientsbyCompanyResponse({
        required this.status,
        required this.code,
        required this.clientes,
    });

    factory ClientsbyCompanyResponse.fromJson(String str) => ClientsbyCompanyResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClientsbyCompanyResponse.fromMap(Map<String, dynamic> json) => ClientsbyCompanyResponse(
        status: json["status"],
        code: json["code"],
        clientes: List<Client>.from(json["data"].map((x) => Client.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "data": List<dynamic>.from(clientes.map((x) => x.toMap())),
    };
}

class Client {
    int id;
    String name;
    String addres;
    String country;
    String dateinit;
    int idcompany;
    String email;

    Client({
        required this.id,
        required this.name,
        required this.addres,
        required this.country,
        required this.dateinit,
        required this.idcompany,
        required this.email,
    });

    factory Client.fromJson(String str) => Client.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Client.fromMap(Map<String, dynamic> json) => Client(
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

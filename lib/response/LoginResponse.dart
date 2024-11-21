// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';


class LoginResponse {
    String status;
    int code;
    String token;

    LoginResponse({
        required this.status,
        required this.code,
        required this.token,
    });

    factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());


    factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        code: json["code"],
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "code": code,
        "token": token,
    };
}

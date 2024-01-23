// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String status;
    int code;
    String token;

    LoginResponse({
        required this.status,
        required this.code,
        required this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        code: json["code"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "token": token,
    };
}

import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rondines/response/getdatacode_Response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../response/gettypeguardsbycompany_Response.dart';
import '../response/response.dart';

class DBProvider extends ChangeNotifier{
  static Database? _database;

  static final DBProvider db=DBProvider._();
  DBProvider._();

  Future<Database> get database async=>_database ??= await initDB();

  Future<Database> initDB() async{
    Directory documentsDirectory=await getApplicationDocumentsDirectory();
    final path=join(documentsDirectory.path,'Segser.db');

    return await openDatabase(
      path,
      version:3,
      onOpen: (db) => {},
      onCreate: (Database db,int version) async{
        await db.execute(
          ''' 
          CREATE TABLE POINT(
            ID INTEGER,
            IDCOMPANY INTEGER,
            IDCLIENT INTEGER,
            NAME TEXT,
            LAT TEXT,
            LONGI TEXT,
            CODE TEXT,
            IDZONE INTEGER,
            ISCRIADERO INTEGER
          )
          '''
        );

        await db.execute(
            ''' 
          CREATE TABLE TYPEGUARD(
            ID INTEGER,
            IDCOMPANY INTEGER,
            NAME TEXT
          )
          '''
        );

        await db.execute(
            ''' 
          CREATE TABLE GUARDS(
            ID INTEGER PRIMARY KEY   AUTOINCREMENT,
            IDUSER INTEGER,
            IDTYPEGUAR INTEGER,
            DATE TEXT,
            TIME TEXT,
            IDPOINT INTEGER,
            LAT TEXT,
            LONGI TEXT,
            OBSERVACION TEXT,
            ISOK TEXT,
            IDIMAGE TEXT,
            TYPEPOINT TEXT,
            SW_ENVIADO TEXT
          ) 
          '''
        );
      }
    );

  }

  Future<int>insertpoint(Point punto)async{
    final db=await database;
    final res=await db.delete('POINT').then((value) => db.insert('POINT',punto.toJson()));
    return res;
  }
  Future<int>inserttypeguard(TipoGuard gurad)async{
    final db=await database;
    final res=await db.delete('TYPEGUARD').then((value) => db.insert('TYPEGUARD',gurad.toJson()));
    return res;
  }

  Future<List<TipoGuard>> gettypeguard() async{
    final db=await database;

    final List<Map<String,dynamic>>res=await db.rawQuery(
      ''' SELECT * FROM TYPEGUARD '''
    );

    return List.generate(res.length, (index) => TipoGuard(
      id: res[index]['ID'],
      name: res[index]['NAME']
    ));
  }
  Future<List<Point>> getpointbycode(String code) async{
    final db=await database;

    final List<Map<String,dynamic>>res=await db.rawQuery(
        ''' SELECT * FROM POINT WHERE CODE= '$code'  '''
    );

    return List.generate(res.length, (index) => Point(
        id: res[index]['ID'],
        name: res[index]['NAME'],
        idclient: res[index]['IDCLIENT'],
        idzone: res[index]['IDZONE']
    ));
  }
  Future<int>insertguard(Guard guardia)async{
    final db=await database;
    final res=await db.insert('GUARDS',guardia.toMap() );
    return res;
  }
  Future<int>updatesync(int id) async {
    final db=await database;

    final res=await db.rawUpdate(''' 
      UPDATE GUARDS SET SW_ENVIADO='1' WHERE ID='$id'
    ''');
    return res;


  }

  Future<List<Guard>>getguarddisponible()async{
    final db=await database;
    final List<Map<String,dynamic>>res=await db.rawQuery(
        ''' SELECT * FROM GUARDS WHERE SW_ENVIADO= '0'  '''

    );

    return List.generate(res.length, (index) => Guard(
        id: res[index]['ID'],
        iduser: res[index]['IDUSER'],
        idtypeguar: res[index]['IDTYPEGUAR'],
        date: res[index]['DATE'],
        time: res[index]['TIME'],
        lat: res[index]['LAT'],
        longi: res[index]['LONGI'],
        idpoint: res[index]['IDPOINT'],
        observacion: res[index]['OBSERVACION'],
        isok: res[index]['ISOK'],
        idimage: res[index]['IDIMAGE'],
        typepoint: res[index]['TYPEPOINT'],
        sw_enviado: res[index]['SW_ENVIADO']

    ));

  }



}
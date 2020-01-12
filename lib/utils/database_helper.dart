import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:member_management/models/member.dart';

class DatabaseHelper {
  static DatabaseHelper _databseHelper;
  static Database _database;

  String memberTable = 'member_table';
  String colId = 'id';
  String colName = 'name';
  String colRegNo = "registration_number";
  String colMobile = 'mobilenumber';
  String colEmail = 'email';
  String colFields = 'fields';
  String colPosition = 'position';
  String colNotes = 'note';
  String colAttendance = "attendance";



  DatabaseHelper._createInstance();


  factory DatabaseHelper(){
    if (_databseHelper == null) {
      _databseHelper = DatabaseHelper._createInstance();
    }
    return _databseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'members.db';

    var noteDatabse = await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDatabse;

  }


  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $memberTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colRegNo INTEGER, $colMobile INTEGER,$colAttendance INTEGER, $colEmail TEXT, $colFields TEXT ,$colPosition TEXT, $colNotes TEXT )");
  }

  //fetch operation
  Future<List<Map<String, dynamic>>> getMemberMapList(String orderName) async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(memberTable, orderBy: '$orderName ASC');
    return result;
  }

  //insert operation
  Future<int> insertMember(Member member) async {
    var db = await this.database;
    debugPrint("got value to insert as ${member.toMap()['fields']}");
    var result = await db.insert(memberTable, member.toMap());
    return result;
  }

  //update operation
  Future<int> updateMember(Member member) async {
    var db = await this.database;
    var result = await db.update(memberTable, member.toMap(), where: '$colId = ?', whereArgs: [member.id]);
    return result;
  }

  //delete operation
  Future<int> deleteMember(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $memberTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $memberTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Member>> getMemberList() async {
    var memberMapList = await getMemberMapList("name");
    int count = memberMapList.length;

    List<Member> memberList = List<Member>();
    for(int i = 0; i < count; i++){
      memberList.add(Member.fromMapObject(memberMapList[i]));
    }
    return memberList;
  }

}
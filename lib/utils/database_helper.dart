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
  String colRegNo = 'RegNo';
  String colMobile = 'Mobile';
  String colEmail = 'email';
  String colFields = 'Fields';
  String colPosition = 'position';
  String colNotes = 'notes';



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
    await db.execute("CREATE TABLE $memberTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colRegNo INTEGER, $colMobile INTEGER, $colEmail TEXT, $colFields TEXT ,$colPosition TEXT, $colNotes TEXT )");
  }

  //fetch operation
  Future<List<Map<String, dynamic>>> getNoteMapList(String orderName) async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(memberTable, orderBy: '$orderName ASC');
    return result;
  }

  //insert operation
  Future<int> insertNote(Member member) async {
    var db = await this.database;
    var result = await db.insert(memberTable, member.toMap());
    return result;
  }

  //update operation
  Future<int> updateNote(Member member) async {
    var db = await this.database;
    var result = await db.update(memberTable, member.toMap(), where: '$colId = ?', whereArgs: [member.id]);
    return result;
  }

  //delete operation
  Future<int> deleteNote(int id) async {
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

  Future<List<Member>> getNoteList() async {
    var noteMapList = await getNoteMapList("name");
    int count = noteMapList.length;

    List<Member> noteList = List<Member>();
    for(int i = 0; i < count; i++){
      noteList.add(Member.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

}
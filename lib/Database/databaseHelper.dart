import 'package:profitbook/Model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database; // Singleton Database

  String transactionTable = 'transaction_table';
  String colId = 'id';
  String colProduct = 'product';
  String colBuy = 'buy';
  String colSell = 'sell';
  String colProfit = 'profit';
  String colProfitInP = 'profitInP';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var transactionDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return transactionDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $transactionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colProduct TEXT, '
        '$colBuy REAL, $colSell REAL, $colProfit REAL,  $colProfitInP REAL,  $colDate TEXT)');
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(transactionTable, orderBy: '$colDate ASC');
    return result;
  }

  //Insert
  Future<int> insertNote(Transactions transaction) async {
    Database db = await this.database;
    var result = await db.insert(transactionTable, transaction.toMap());
    return result;
  }

  // //Update
  // Future<int> updateNote(Transactions transactions) async {
  //   var db = await this.database;
  //   var result = await db.update(transactionTable, transactions.toMap(),
  //       where: '$colId = ?', whereArgs: [transactions.id]);
  //   return result;
  // }

  //Delete
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $transactionTable WHERE $colId = $id');
    return result;
  }

  //Get number of Objects
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT SUM ($colBuy) from $transactionTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Transactions>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Transactions> noteList = List<Transactions>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Transactions.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  // Future<int> s() async {
  //   Database db = await this.database;
  //
  //   List<Map<String, dynamic>> x =
  //       await db.rawQuery('SELECT SUM ($colBuy) from $transactionTable');
  //   var result = Sqflite.firstIntValue(x);
  //   return result;
  // }

  Future calculateBuy() async {
    var dbClient = await this.database; // couldnt figure out after this
    var cursor = dbClient.rawQuery(
        "SELECT SUM($colBuy) as Total FROM $transactionTable", null);
    return cursor;
  }

  Future calculateSell() async {
    var dbClient = await this.database; // couldnt figure out after this
    var cursor = dbClient.rawQuery(
        "SELECT SUM($colSell) as Total FROM $transactionTable", null);
    return cursor;
  }
}

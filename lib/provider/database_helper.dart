import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videos_app/core/model/download_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "downloads.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Downloads(id INTEGER PRIMARY KEY AUTOINCREMENT,courseId INTEGER, url TEXT,downloadUrl TEXT,lessonTitle TEXT,courseTitle TEXT, progress REAL, status TEXT, path TEXT)",
    );
  }

  // Create a new DownloadModel
  Future<int> createDownload(DownloadModel download) async {
    var dbClient = await db;
    var res = await dbClient!
        .query("Downloads", where: "id = ?", whereArgs: [download.id]);

    if (res.isNotEmpty) {
      int updatedRows = await dbClient.update("Downloads", download.toJson(),
          where: "id = ?", whereArgs: [download.id]);
      return updatedRows;
    } else {
      int insertedId = await dbClient.insert("Downloads", download.toJson());
      return insertedId;
    }
  }

  // Fetch all DownloadModels
  Future<List<DownloadModel>> getDownloads() async {
    log('getDownloads');
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient!.query("Downloads");
    List<DownloadModel> downloads = [];
    for (var row in result) {
      downloads.add(DownloadModel.fromJson(row));
      String jsonString = json.encode(result);
      List<dynamic> parsedJson = json.decode(jsonString);

      log("What left in Database : ${parsedJson.length}");
    }
    return downloads;
  }

  // Update a DownloadModel
  Future<int> updateDownload(DownloadModel download) async {
    var dbClient = await db;
    int res = await dbClient!.update("Downloads", download.toJson(),
        where: "id = ?", whereArgs: [download.id]);
    return res;
  }

  // Delete a DownloadModel
  Future<int> deleteDownload(int id) async {
    var dbClient = await db;
    int res =
        await dbClient!.delete("Downloads", where: "id = ?", whereArgs: [id]);
    return res;
  }

  // Close the database
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

  Future<void> deleteDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "downloads.db");

    bool doesDatabaseExist = await databaseExists(path);
    var dbClient = await db;

    if (doesDatabaseExist) {
      try {
        await dbClient!.rawDelete("DELETE FROM Downloads");
      } catch (e) {
        log('Can\'t delete ');
      }
    } else {
      null;
    }
  }
}

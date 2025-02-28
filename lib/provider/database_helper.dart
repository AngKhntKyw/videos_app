import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videos_app/core/model/download_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();
  DatabaseHelper.init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "downloads.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: onCreate);
    return ourDb;
  }

  void onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Downloads(id INTEGER PRIMARY KEY AUTOINCREMENT,courseId INTEGER,lessonId INTEGER, url TEXT,downloadUrl TEXT,lessonTitle TEXT,courseTitle TEXT, progress REAL, status TEXT, path TEXT)",
    );
    log("Database just created");
  }

  // Create a new DownloadModel
  Future<int> createDownloadModel(DownloadModel downloadModel) async {
    var dbClient = await database;
    var res = await dbClient
        .query("Downloads", where: "id = ?", whereArgs: [downloadModel.id]);

    if (res.isNotEmpty) {
      int updatedRows = await dbClient.update(
          "Downloads", downloadModel.toJson(),
          where: "id = ?", whereArgs: [downloadModel.id]);
      return updatedRows;
    } else {
      int insertedId =
          await dbClient.insert("Downloads", downloadModel.toJson());
      return insertedId;
    }
  }

  // Fetch all DownloadModels
  Future<List<DownloadModel>> getDownloads() async {
    var dbClient = await database;
    List<Map<String, dynamic>> result = await dbClient.query("Downloads");
    List<DownloadModel> downloads = [];
    for (var row in result) {
      downloads.add(DownloadModel.fromJson(row));
    }
    return downloads;
  }

  // Delete the whole database
  Future<void> deleteDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "downloads.db");

    bool doesDatabaseExist = await databaseExists(path);
    var dbClient = await database;

    if (doesDatabaseExist) {
      try {
        await dbClient.rawDelete("DELETE FROM Downloads");
      } catch (e) {
        log('Can\'t delete ');
      }
    } else {
      null;
    }
  }

  // Update a DownloadModel
  Future<int> updateDownload(DownloadModel download) async {
    var dbClient = await database;
    int res = await dbClient.update("Downloads", download.toJson(),
        where: "id = ?", whereArgs: [download.id]);
    return res;
  }
}

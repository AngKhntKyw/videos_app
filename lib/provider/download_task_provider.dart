import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/database_helper.dart';

class DownloadTaskProvider with ChangeNotifier {
  final DatabaseHelper db = GetIt.instance.get<DatabaseHelper>();
  DownloadTaskProvider() {
    initAsync();
  }

  void initAsync() async {
    downloadTasks = await db.getDownloads();
  }

  DownloadModel? _currentTask;
  DownloadModel? get currentTask => _currentTask;

  List<DownloadModel> downloadTasks = [];

  void startDownload(DownloadModel downloadModel, BuildContext context) async {
    downloadModel.status = DownloadStatus.running;
    context.read<CourseProvider>().updateCourse(downloadModel);
    _currentTask = downloadModel;
    await db.createDownload(_currentTask!);
  }
}

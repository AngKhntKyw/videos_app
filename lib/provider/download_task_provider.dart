import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/database_helper.dart';
import 'package:videos_app/provider/m3u8_downloader.dart';

class DownloadTaskProvider with ChangeNotifier {
  final CourseProvider courseProvider;
  DownloadTaskProvider(this.courseProvider);

  final DatabaseHelper dm = DatabaseHelper();
  DownloadModel? _currentTask;
  DownloadModel? get currentTask => _currentTask;

  List<DownloadModel> downloadTasks = [];

  errorCall(dynamic data) async {
    _currentTask!.status = DownloadStatus.none;
    downloadTasks.remove(_currentTask!);
    courseProvider.updateCourse(currentTask!);
    await dm.updateDownload(currentTask!);
    _currentTask = null;
    // nextDownload();
    notifyListeners();
  }

  successCall(dynamic data) async {
    currentTask?.progress = 1.0;
    currentTask?.status = DownloadStatus.success;
    final filePath = data['filePath'] as String;
    currentTask?.path = filePath;
    courseProvider.updateCourse(currentTask!);
    await dm.updateDownload(currentTask!);
    downloadTasks.remove(currentTask);
    _currentTask = null;
    // nextDownload();
    notifyListeners();
  }

  progressCall(dynamic data) async {
    _currentTask!.progress = data['progress'] as double;
    await dm.updateDownload(currentTask!);
    courseProvider.updateCourse(currentTask!);
    notifyListeners();
  }

  void startDownload(DownloadModel downloadModel, BuildContext context) async {
    log('CurrentTask : $currentTask');
    if (currentTask == null) {
      _currentTask = downloadModel;
      currentTask!.courseId = courseProvider.currentCourse?.id;

      downloadModel.status = DownloadStatus.running;

      await dm.createDownload(currentTask!);

      final savePath =
          await M3U8Downloader.instance.getSavePath(downloadModel.lessonTitle!);

      M3U8Downloader.instance.download(
        url: downloadModel.downloadUrl!,
        lessonTitle: savePath,
        onStart: (sessionId) {},
        onProgress: progressCall,
        onSuccess: successCall,
        onError: errorCall,
      );
      courseProvider.updateCourse(downloadModel);
    } else {
      downloadModel.status = DownloadStatus.waiting;
      downloadModel.courseId = courseProvider.currentCourse?.id;
      downloadTasks.add(downloadModel);
      await dm.createDownload(downloadModel);
      courseProvider.updateCourse(downloadModel);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<bool?> delete(String url, DownloadModel dmm, int lessonId) async {
    bool result = false;

    /// 1 -> Find for storage
    result = await M3U8Downloader.instance.delete(dmm.lessonTitle!);
    // log('$kTAG Delete Success in storage! $result');

    /// 2 -> Update Status for Can download
    dmm.status = DownloadStatus.none;

    /// 3 -> remove from download tasks if exist
    downloadTasks.removeWhere((dt) => dt.courseId == dmm.courseId);

    /// 4 -> update state
    deleteLesson(dmm);

    /// 5 ->  Delete from local db
    await dm.deleteDownload(dmm.id!);
    // log('$kTAG Delete Success in Database!');
    notifyListeners();
    return result;
  }

  void deleteLesson(DownloadModel dm) {
    courseProvider.deleteLesson(dm);
  }
}

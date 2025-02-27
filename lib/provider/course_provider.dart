// import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:videos_app/core/model/course.dart';
// import 'package:videos_app/core/model/download_model.dart';
// import 'package:videos_app/core/model/lesson.dart';
// import 'package:videos_app/provider/local_storage.dart';
// import 'package:videos_app/provider/m3u8_downloader.dart';

// class CourseProvider with ChangeNotifier {
//   Course? _currentCourse;
//   Course? get currentCourse => _currentCourse;

//   final List<BetterPlayerDataSource> _dataSourceList = [];
//   List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

//   List<Lesson> _videoLessons = [];
//   List<Lesson> get videoLessons => _videoLessons;

//   Lesson? _watchingLesson;
//   Lesson? get watchingLesson => _watchingLesson;

//   final M3U8Downloader _downloader = M3U8Downloader();
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;
//   bool _isDownloading = false;

//   List<DownloadModel> _downloadsCache = []; // Cached list of downloads

//   CourseProvider() {
//     _initDownloads();
//   }

//   void setUpVideoDataSource({required Course course}) async {
//     _dataSourceList.clear();
//     _videoLessons.clear();
//     _currentCourse = course;

//     _dataSourceList.add(createDataSource(course.introVideoUrl, null));

//     _videoLessons = course.units
//         .where((e) => e.lessons.isNotEmpty)
//         .expand((unit) => unit.lessons)
//         .where((lesson) => lesson.lessonUrl != null)
//         .toList();

//     final downloads = await _dbHelper.getDownloads();
//     _downloadsCache = downloads;

//     for (Lesson lesson in _videoLessons) {
//       final download = _downloadsCache.firstWhere(
//         (d) => d.lessonId == lesson.id,
//         orElse: () => DownloadModel(
//           courseId: course.id,
//           lessonId: lesson.id,
//           lessonTitle: lesson.title,
//           downloadUrl: lesson.lessonUrl,
//           courseTitle: course.title,
//           id: course.id,
//           path: '',
//           progress: 0,
//           url: lesson.lessonUrl,
//           status: DownloadStatus.none,
//         ),
//       );
//       if (!_downloadsCache.any((d) => d.lessonId == lesson.id)) {
//         await _dbHelper.createDownloadModel(download);
//         _downloadsCache.add(download);
//       }
//       _dataSourceList.add(createDataSource(lesson.lessonUrl, lesson));
//     }

//     notifyListeners();
//   }

//   BetterPlayerDataSource createDataSource(String? url, Lesson? lesson) {
//     String? localPath;
//     if (lesson != null) {
//       final download = getDownloadModelForLesson(lesson);
//       localPath = download!.path;
//     }
//     final effectiveUrl =
//         localPath ?? url ?? "https://www.youtube.com/watch?v=BgazxvsE0Uk";
//     final isLocal = localPath != null;

//     return isLocal
//         ? BetterPlayerDataSource.file(
//             effectiveUrl,
//             cacheConfiguration: BetterPlayerCacheConfiguration(
//               key: lesson?.lessonUrl ?? url,
//               useCache: false,
//             ),
//           )
//         : BetterPlayerDataSource.network(
//             effectiveUrl,
//             videoFormat: BetterPlayerVideoFormat.hls,
//             cacheConfiguration: BetterPlayerCacheConfiguration(
//               key: lesson?.lessonUrl ?? url,
//               useCache: true,
//               preCacheSize: 10 * 2024 * 2024,
//               maxCacheSize: 10 * 1024 * 1024,
//               maxCacheFileSize: 50 * 1024 * 1024,
//             ),
//           );
//   }

//   Future<void> _initDownloads() async {
//     _downloadsCache = await _dbHelper.getDownloads();
//     notifyListeners();
//     _startAutoDownload();
//   }

//   Future<void> _startAutoDownload() async {
//     if (_isDownloading) return;

//     final queuedDownloads = _downloadsCache
//         .where((d) => d.status == DownloadStatus.waiting)
//         .toList();

//     if (queuedDownloads.isEmpty) return;

//     _isDownloading = true;
//     for (final download in queuedDownloads) {
//       await _downloadVideo(download);
//     }
//     _isDownloading = false;

//     _startAutoDownload();
//   }

//   Future<void> _downloadVideo(DownloadModel download) async {
//     if (download.downloadUrl == null) return;

//     // Update to running
//     final runningDownload = download.copyWith(status: DownloadStatus.running);
//     _updateDownloadInCache(runningDownload);
//     await _dbHelper.updateDownload(runningDownload);
//     notifyListeners();

//     final localPath = await _downloader.download(
//       url: download.downloadUrl!,
//       lessonTitle: download.lessonTitle!,
//       onProgress: (progress) async {
//         final updatedDownload = download.copyWith(progress: progress);
//         _updateDownloadInCache(updatedDownload);
//         await _dbHelper.updateDownload(updatedDownload);
//         notifyListeners();
//       },
//     );

//     final updatedDownload = download.copyWith(
//       status: localPath != null ? DownloadStatus.success : DownloadStatus.fail,
//       path: localPath,
//       progress: localPath != null ? 1.0 : download.progress,
//     );
//     _updateDownloadInCache(updatedDownload);
//     await _dbHelper.updateDownload(updatedDownload);
//     notifyListeners();

//     // Update data source if the lesson is in the current list
//     final lessonIndex =
//         _videoLessons.indexWhere((l) => l.id == download.lessonId);
//     if (lessonIndex != -1) {
//       _dataSourceList[lessonIndex + 1] = createDataSource(
//           _videoLessons[lessonIndex].lessonUrl, _videoLessons[lessonIndex]);
//       notifyListeners();
//     }
//   }

//   void queueForDownload(Lesson lesson) async {
//     final download = getDownloadModelForLesson(lesson);
//     if (download!.status != DownloadStatus.success) {
//       final queuedDownload = download.copyWith(status: DownloadStatus.waiting);
//       _updateDownloadInCache(queuedDownload);
//       await _dbHelper.createDownloadModel(queuedDownload);
//       notifyListeners();
//       _startAutoDownload();
//     }
//   }

//   Future<List<DownloadModel>> getLocalDownloads() async {
//     return _downloadsCache;
//   }

//   Future<void> deleteLocallDatabase() async {
//     await _dbHelper.deleteDatabase();
//     _downloadsCache.clear();
//     notifyListeners();
//   }

//   DownloadModel? getDownloadModelForLesson(Lesson lesson) {
//     return _downloadsCache.firstWhere(
//       (d) => d.lessonId == lesson.id,
//       orElse: () => DownloadModel(
//         courseId: _currentCourse?.id,
//         lessonId: lesson.id,
//         lessonTitle: lesson.title,
//         downloadUrl: lesson.lessonUrl,
//         status: DownloadStatus.none,
//       ),
//     );
//   }

//   void _updateDownloadInCache(DownloadModel download) {
//     final index =
//         _downloadsCache.indexWhere((d) => d.lessonId == download.lessonId);
//     if (index != -1) {
//       _downloadsCache[index] = download;
//     } else {
//       _downloadsCache.add(download);
//     }
//   }

//   int findDataSourceIndexByLesson({required Lesson lesson}) {
//     final download = getDownloadModelForLesson(lesson);
//     final searchUrl = download!.path ?? lesson.lessonUrl;
//     final index =
//         _dataSourceList.indexWhere((element) => element.url == searchUrl);
//     return index;
//   }

//   Lesson findLessonByDataSourceIndex({required int? index}) {
//     return _videoLessons.firstWhere(
//         (element) => _dataSourceList[index!].url == element.lessonUrl,
//         orElse: () => _videoLessons.first);
//   }

//   void setWatchingLesson({required Lesson lesson}) {
//     _watchingLesson = lesson;
//     notifyListeners();
//   }

//   bool isLessonWatching({required int lessonId}) {
//     final isWatching = _watchingLesson?.id == lessonId;
//     return isWatching;
//   }

//   void clearDataSources() {
//     _dataSourceList.clear();
//     _videoLessons.clear();
//     _currentCourse = null;
//     _watchingLesson = null;
//     notifyListeners();
//   }
// }

import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/local_storage.dart';
import 'package:videos_app/provider/m3u8_downloader.dart';

class CourseProvider with ChangeNotifier {
  Course? _currentCourse;
  Course? get currentCourse => _currentCourse;

  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  Lesson? _watchingLesson;
  Lesson? get watchingLesson => _watchingLesson;

  final M3U8Downloader _downloader = M3U8Downloader();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isDownloading = false;

  List<DownloadModel> _downloadsCache = []; // Cached list of downloads

  CourseProvider() {
    _initDownloads();
  }

  void setUpVideoDataSource({required Course course}) async {
    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse = course;

    _dataSourceList.add(createDataSource(course.introVideoUrl, null));

    _videoLessons = course.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonUrl != null)
        .toList();

    final downloads = await _dbHelper.getDownloads();
    _downloadsCache = downloads;

    for (Lesson lesson in _videoLessons) {
      final download = _downloadsCache.firstWhere(
        (d) => d.lessonId == lesson.id,
        orElse: () => DownloadModel(
          courseId: course.id,
          lessonId: lesson.id,
          lessonTitle: lesson.title,
          downloadUrl: lesson.lessonUrl,
          status: DownloadStatus.none,
        ),
      );
      if (!_downloadsCache.any((d) => d.lessonId == lesson.id)) {
        await _dbHelper.createDownloadModel(download);
        _downloadsCache.add(download);
      }
      _dataSourceList.add(createDataSource(lesson.lessonUrl, lesson));
    }

    notifyListeners();
  }

  BetterPlayerDataSource createDataSource(String? url, Lesson? lesson) {
    String? localPath;
    if (lesson != null) {
      final download = getDownloadModelForLesson(lesson);
      localPath = download!.path;
      log("Creating data source for ${lesson.title}: Local path = $localPath, URL = $url, Status = ${download.status!.name}");
    }
    final effectiveUrl =
        localPath ?? url ?? "https://www.youtube.com/watch?v=BgazxvsE0Uk";
    final isLocal = localPath != null;

    return isLocal
        ? BetterPlayerDataSource.file(
            effectiveUrl,
            cacheConfiguration: BetterPlayerCacheConfiguration(
              key: lesson?.lessonUrl ?? url,
              useCache: false,
            ),
          )
        : BetterPlayerDataSource.network(
            effectiveUrl,
            videoFormat: BetterPlayerVideoFormat.hls,
            cacheConfiguration: BetterPlayerCacheConfiguration(
              key: lesson?.lessonUrl ?? url,
              useCache: true,
              preCacheSize: 10 * 2024 * 2024,
              maxCacheSize: 10 * 1024 * 1024,
              maxCacheFileSize: 50 * 1024 * 1024,
            ),
          );
  }

  Future<void> _initDownloads() async {
    _downloadsCache = await _dbHelper.getDownloads();
    notifyListeners();
    _startAutoDownload();
  }

  Future<void> _startAutoDownload() async {
    if (_isDownloading) return;

    final queuedDownloads = _downloadsCache
        .where((d) => d.status == DownloadStatus.waiting)
        .toList();

    if (queuedDownloads.isEmpty) return;

    _isDownloading = true;
    for (final download in queuedDownloads) {
      await _downloadVideo(download);
    }
    _isDownloading = false;

    _startAutoDownload();
  }

  Future<void> _downloadVideo(DownloadModel download) async {
    if (download.downloadUrl == null) return;

    // Update to running
    final runningDownload = download.copyWith(status: DownloadStatus.running);
    _updateDownloadInCache(runningDownload);
    await _dbHelper.updateDownload(runningDownload);
    notifyListeners();

    final localPath = await _downloader.download(
      url: download.downloadUrl!,
      lessonTitle: download.lessonTitle!,
      onProgress: (progress) async {
        final updatedDownload = download.copyWith(progress: progress);
        _updateDownloadInCache(updatedDownload);
        await _dbHelper.updateDownload(updatedDownload);
        notifyListeners();
      },
    );

    final updatedDownload = download.copyWith(
      status: localPath != null ? DownloadStatus.success : DownloadStatus.fail,
      path: localPath,
      progress: localPath != null ? 1.0 : download.progress,
    );
    _updateDownloadInCache(updatedDownload);
    await _dbHelper.updateDownload(updatedDownload);
    notifyListeners();

    // Update data source if the lesson is in the current list
    final lessonIndex =
        _videoLessons.indexWhere((l) => l.id == download.lessonId);
    if (lessonIndex != -1) {
      _dataSourceList[lessonIndex + 1] = createDataSource(
          _videoLessons[lessonIndex].lessonUrl, _videoLessons[lessonIndex]);
      notifyListeners();
    }
  }

  void queueForDownload(Lesson lesson) async {
    final download = getDownloadModelForLesson(lesson);
    if (download!.status != DownloadStatus.success) {
      final queuedDownload = download.copyWith(status: DownloadStatus.waiting);
      _updateDownloadInCache(queuedDownload);
      await _dbHelper.createDownloadModel(queuedDownload);
      notifyListeners();
      _startAutoDownload();
    }
  }

  Future<List<DownloadModel>> getLocalDownloads() async {
    return _downloadsCache;
  }

  Future<void> deleteLocallDatabase() async {
    await _dbHelper.deleteDatabase();
    _downloadsCache.clear();
    notifyListeners();
  }

  DownloadModel? getDownloadModelForLesson(Lesson lesson) {
    return _downloadsCache.firstWhere(
      (d) => d.lessonId == lesson.id,
      orElse: () => DownloadModel(
        courseId: _currentCourse?.id,
        lessonId: lesson.id,
        lessonTitle: lesson.title,
        downloadUrl: lesson.lessonUrl,
        status: DownloadStatus.none,
      ),
    );
  }

  void _updateDownloadInCache(DownloadModel download) {
    final index =
        _downloadsCache.indexWhere((d) => d.lessonId == download.lessonId);
    if (index != -1) {
      _downloadsCache[index] = download;
    } else {
      _downloadsCache.add(download);
    }
  }

  int findDataSourceIndexByLesson({required Lesson lesson}) {
    final download = getDownloadModelForLesson(lesson);
    final searchUrl = download!.path ?? lesson.lessonUrl;
    log("Searching for URL: $searchUrl in data source list");
    final index =
        _dataSourceList.indexWhere((element) => element.url == searchUrl);
    log("Found index: $index");
    return index;
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _videoLessons.firstWhere(
        (element) => _dataSourceList[index!].url == element.lessonUrl,
        orElse: () => _videoLessons.first);
  }

  void setWatchingLesson({required Lesson lesson}) {
    _watchingLesson = lesson;
    notifyListeners();
  }

  bool isLessonWatching({required int lessonId}) {
    return _watchingLesson?.id == lessonId;
  }

  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse = null;
    _watchingLesson = null;
    notifyListeners();
  }
}

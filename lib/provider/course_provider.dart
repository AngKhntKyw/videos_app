import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/lesson.dart';

class CourseProvider with ChangeNotifier {
  //
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();
  //
  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  Lesson? _watchingLesson;
  Lesson? get watchingLesson => _watchingLesson;

  void setUpVideoDataSource({required Course course}) {
    _dataSourceList.clear();
    _videoLessons.clear();
    // add intro video into dataSourceList
    _dataSourceList.add(BetterPlayerDataSource.network(
      course.introVideoUrl,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        key: course.introVideoUrl,
        useCache: true,
        preCacheSize: 10 * 2024 * 2024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 50 * 1024 * 1024,
      ),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 20000,
        maxBufferMs: 50000,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
    ));

    //
    _videoLessons = course.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList();

    for (Lesson lesson in _videoLessons) {
      _dataSourceList.add(
        BetterPlayerDataSource.network(
          lesson.lessonUrl,
          cacheConfiguration: BetterPlayerCacheConfiguration(
            key: lesson.lessonUrl,
            useCache: true,
            preCacheSize: 10 * 2024 * 2024,
            maxCacheSize: 10 * 1024 * 1024,
            maxCacheFileSize: 50 * 1024 * 1024,
          ),
          bufferingConfiguration: const BetterPlayerBufferingConfiguration(
            minBufferMs: 20000,
            maxBufferMs: 50000,
            bufferForPlaybackMs: 2500,
            bufferForPlaybackAfterRebufferMs: 5000,
          ),
        ),
      );
    }
  }

  int findDataSourceIndexByLesson({required Lesson lesson}) {
    return _dataSourceList
        .indexWhere((element) => element.url == lesson.lessonUrl);
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _videoLessons.firstWhere(
        (element) => _dataSourceList[index!].url == element.lessonUrl,
        orElse: () => _videoLessons.first);
  }

  bool isLessonWatching({required int lessonId}) {
    if (_watchingLesson != null) {
      return _watchingLesson!.id == lessonId;
    }
    return false;
  }

  void setWatchingLesson({required Lesson lesson}) async {
    _watchingLesson = lesson;
    notifyListeners();
  }

  int getLastWatchingLesson() {
    return _watchingLesson == null
        ? 0
        : _dataSourceList
            .indexWhere((element) => element.url == _watchingLesson?.lessonUrl);
  }

  //
  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
  }
}



//  if (_watchingLesson == null) {
//       null;
//     } else {
//       final index = _currentPositionPerLesson.indexWhere((map) =>
//           map['lessonId'] ==
//           findLessonDataSourceIndex(lesson: _watchingLesson!));

//       if (index != -1) {
//         _currentPositionPerLesson[index]['position'] = position;
//         log("update existed");
//       } else {
//         _currentPositionPerLesson.add({
//           'lessonId': findLessonDataSourceIndex(lesson: _watchingLesson!),
//           'position': position,
//         });
//         log("add new");
//       }
//       notifyListeners();
//     }

//  if (_watchingLesson == null) {
//       return const Duration(seconds: 0);
//     } else {
//       final map = _currentPositionPerLesson.firstWhere(
//         (map) =>
//             map['lessonId'] ==
//             findLessonDataSourceIndex(lesson: _watchingLesson!),
//         orElse: () => {},
//       );

//       return map['position'] as Duration?;
//     }
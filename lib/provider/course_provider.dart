import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/lesson.dart';

class CourseProvider with ChangeNotifier {
  //
  Course? _currentCourse;
  Course? get currentCourse => _currentCourse;

  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  Lesson? _watchingLesson;
  Lesson? get watchingLesson => _watchingLesson;

  void setUpVideoDataSource({required Course course}) {
    // assign current course

    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse == null;
    _currentCourse = course;

    // add intro video into dataSourceLists

    _dataSourceList.add(
      BetterPlayerDataSource.network(
        course.introVideoUrl,
        drmConfiguration: BetterPlayerDrmConfiguration(),
        liveStream: false,
        useAsmsTracks: true,
        videoFormat: BetterPlayerVideoFormat.hls,
        useAsmsAudioTracks: true,
        useAsmsSubtitles: true,
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
      ),
    );

    //
    _videoLessons = course.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList();

    for (Lesson lesson in _videoLessons) {
      _dataSourceList.add(
        BetterPlayerDataSource.network(
          lesson.lessonUrl ?? "https://www.youtube.com/watch?v=BgazxvsE0Uk",
          drmConfiguration: BetterPlayerDrmConfiguration(),
          liveStream: false,
          useAsmsTracks: true,
          videoFormat: BetterPlayerVideoFormat.hls,
          useAsmsAudioTracks: true,
          useAsmsSubtitles: true,
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
    return _dataSourceList.indexWhere((element) =>
        element.url ==
        (lesson.lessonUrl ?? "https://www.youtube.com/watch?v=BgazxvsE0Uk"));
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _videoLessons.firstWhere(
        (element) => _dataSourceList[index!].url == element.lessonUrl,
        orElse: () => _videoLessons.first);
  }

  void setWatchingLesson({required Lesson lesson}) async {
    _watchingLesson = lesson;
    notifyListeners();
  }

  bool isLessonWatching({required int lessonId}) {
    if (_watchingLesson != null) {
      return _watchingLesson!.id == lessonId;
    }
    return false;
  }

  //
  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse = null;
  }
}

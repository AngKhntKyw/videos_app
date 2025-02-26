import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/database_helper.dart';
import 'package:videos_app/provider/m3u8_downloader.dart';

class CourseProvider with ChangeNotifier {
  DatabaseHelper db = GetIt.instance.get<DatabaseHelper>();

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
    _currentCourse = course;
    _dataSourceList.clear();
    _videoLessons.clear();

    // add intro video into dataSourceLists

    _dataSourceList.add(
      BetterPlayerDataSource.network(course.introVideoUrl),
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
            lesson.lessonUrl ?? "https://www.youtube.com/watch?v=BgazxvsE0Uk"),
      );
    }
    notifyListeners();
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

  Lesson? findLessonByDownloadModelId({required int downloadModelId}) {
    for (var unit in _currentCourse!.units) {
      for (var lesson in unit.lessons) {
        if (lesson.downloadModel?.id == downloadModelId) {
          return lesson;
        }
      }
    }
    return null;
  }

  bool isLessonWatching({required int lessonId}) {
    if (_watchingLesson != null) {
      return _watchingLesson!.id == lessonId;
    }
    return false;
  }

  void updateCourse(DownloadModel downloadModel) {
    if (_currentCourse != null) {
      final foundLesson =
          findLessonByDownloadModelId(downloadModelId: downloadModel.id!);
      if (foundLesson != null) {
        foundLesson.downloadModel = downloadModel;

        if (downloadModel.path != null && downloadModel.path!.isNotEmpty) {
          foundLesson.downloadModel!.courseId = _currentCourse!.id;
          foundLesson.downloadModel!.path = downloadModel.path;
          foundLesson.downloadModel!.courseTitle = _currentCourse!.title;

          final foundDc =
              _dataSourceList.firstWhere((e) => e.url == downloadModel.url);

          final idx = _dataSourceList.indexOf(foundDc);
          _dataSourceList[idx] =
              BetterPlayerDataSource.file(downloadModel.path!);
          notifyListeners();
        } else {
          final foundDc =
              _dataSourceList.firstWhere((e) => e.url == downloadModel.url);
          final idx = _dataSourceList.indexOf(foundDc);
          _dataSourceList[idx] =
              BetterPlayerDataSource.network(downloadModel.url!);
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  //
  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse = null;
  }
}

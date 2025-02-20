import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/lesson.dart';

class CourseProvider with ChangeNotifier {
  //
  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  void setUpVideoDataSource({required Course course}) {
    _dataSourceList.clear();
    videoLessons.clear();
    // add intro video into dataSourceList
    _dataSourceList.add(BetterPlayerDataSource.network(course.introVideoUrl));

    //
    _videoLessons = course.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList();

    for (Lesson lesson in _videoLessons) {
      _dataSourceList.add(BetterPlayerDataSource.network(lesson.lessonUrl));
    }
  }

  int findLessonDataSourceIndex({required Lesson lesson}) {
    return _dataSourceList
        .indexWhere((element) => element.url == lesson.lessonUrl);
  }

  //
  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
  }
}

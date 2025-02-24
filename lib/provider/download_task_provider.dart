import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/provider/course_provider.dart';

class DownloadTaskProvider with ChangeNotifier {
  final CourseProvider courseProvider;
  DownloadTaskProvider(this.courseProvider) {
    init();
  }

  DownloadModel? _currentTask;
  DownloadModel? get currentTask => _currentTask;

  void init() {
    log("Init Download task provider.");
  }
}

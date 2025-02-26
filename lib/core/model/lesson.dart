import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app/core/model/download_model.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@unfreezed
@JsonSerializable(explicitToJson: true)
class Lesson with _$Lesson {
  const Lesson._();

  factory Lesson({
    required int id,
    required String title,
    required String description,
    required String instruction,
    String? lessonType,
    String? lessonUrl,
    @Default(false) bool isDownloaded,
    DownloadModel? downloadModel,
  }) = _Lesson;

  // Override the factory constructor to auto-assign DownloadModel
  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json)
    ..downloadModel = DownloadModel(
      id: json['id'] as int,
      courseId: 0,
      courseTitle: json['title'] as String,
      url: json['lessonUrl'] as String?,
      downloadUrl: json['lessonUrl'] as String?,
      lessonTitle: json['title'] as String,
      progress: 0.0,
      status: DownloadStatus.none,
      path: '',
    );
}

enum DownloadStatus {
  none,
  waiting,
  running,
  success,
  fail,
}

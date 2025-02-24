import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app/core/model/download_model.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const Lesson._();

  const factory Lesson({
    required int id,
    required String title,
    required String description,
    required String instruction,
    String? lessonType,
    String? lessonUrl,
    DownloadModel? downloadModel,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

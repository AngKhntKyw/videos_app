import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app/core/model/unit.dart';
part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course with _$Course {
  const Course._();

  const factory Course({
    required int id,
    required String title,
    required String description,
    required String imgUrl,
    required String introVideoUrl,
    required double price,
    required String outline,
    required List<Unit> units,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}

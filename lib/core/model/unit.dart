import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app/core/model/lesson.dart';
part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const Unit._();

  const factory Unit({
    required int id,
    required String name,
    required List<Lesson> lessons,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}

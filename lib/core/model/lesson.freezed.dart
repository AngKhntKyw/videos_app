// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return _Lesson.fromJson(json);
}

/// @nodoc
mixin _$Lesson {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get instruction => throw _privateConstructorUsedError;
  String? get lessonType => throw _privateConstructorUsedError;
  String? get lessonUrl => throw _privateConstructorUsedError;
  DownloadModel? get downloadModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LessonCopyWith<Lesson> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res, Lesson>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String instruction,
      String? lessonType,
      String? lessonUrl,
      DownloadModel? downloadModel});

  $DownloadModelCopyWith<$Res>? get downloadModel;
}

/// @nodoc
class _$LessonCopyWithImpl<$Res, $Val extends Lesson>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? instruction = null,
    Object? lessonType = freezed,
    Object? lessonUrl = freezed,
    Object? downloadModel = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      lessonType: freezed == lessonType
          ? _value.lessonType
          : lessonType // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonUrl: freezed == lessonUrl
          ? _value.lessonUrl
          : lessonUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadModel: freezed == downloadModel
          ? _value.downloadModel
          : downloadModel // ignore: cast_nullable_to_non_nullable
              as DownloadModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DownloadModelCopyWith<$Res>? get downloadModel {
    if (_value.downloadModel == null) {
      return null;
    }

    return $DownloadModelCopyWith<$Res>(_value.downloadModel!, (value) {
      return _then(_value.copyWith(downloadModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LessonImplCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$$LessonImplCopyWith(
          _$LessonImpl value, $Res Function(_$LessonImpl) then) =
      __$$LessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String instruction,
      String? lessonType,
      String? lessonUrl,
      DownloadModel? downloadModel});

  @override
  $DownloadModelCopyWith<$Res>? get downloadModel;
}

/// @nodoc
class __$$LessonImplCopyWithImpl<$Res>
    extends _$LessonCopyWithImpl<$Res, _$LessonImpl>
    implements _$$LessonImplCopyWith<$Res> {
  __$$LessonImplCopyWithImpl(
      _$LessonImpl _value, $Res Function(_$LessonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? instruction = null,
    Object? lessonType = freezed,
    Object? lessonUrl = freezed,
    Object? downloadModel = freezed,
  }) {
    return _then(_$LessonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      lessonType: freezed == lessonType
          ? _value.lessonType
          : lessonType // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonUrl: freezed == lessonUrl
          ? _value.lessonUrl
          : lessonUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadModel: freezed == downloadModel
          ? _value.downloadModel
          : downloadModel // ignore: cast_nullable_to_non_nullable
              as DownloadModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonImpl extends _Lesson {
  const _$LessonImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.instruction,
      this.lessonType,
      this.lessonUrl,
      this.downloadModel})
      : super._();

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String instruction;
  @override
  final String? lessonType;
  @override
  final String? lessonUrl;
  @override
  final DownloadModel? downloadModel;

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, description: $description, instruction: $instruction, lessonType: $lessonType, lessonUrl: $lessonUrl, downloadModel: $downloadModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.lessonType, lessonType) ||
                other.lessonType == lessonType) &&
            (identical(other.lessonUrl, lessonUrl) ||
                other.lessonUrl == lessonUrl) &&
            (identical(other.downloadModel, downloadModel) ||
                other.downloadModel == downloadModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      instruction, lessonType, lessonUrl, downloadModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      __$$LessonImplCopyWithImpl<_$LessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonImplToJson(
      this,
    );
  }
}

abstract class _Lesson extends Lesson {
  const factory _Lesson(
      {required final int id,
      required final String title,
      required final String description,
      required final String instruction,
      final String? lessonType,
      final String? lessonUrl,
      final DownloadModel? downloadModel}) = _$LessonImpl;
  const _Lesson._() : super._();

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get instruction;
  @override
  String? get lessonType;
  @override
  String? get lessonUrl;
  @override
  DownloadModel? get downloadModel;
  @override
  @JsonKey(ignore: true)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
  set id(int value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  set description(String value) => throw _privateConstructorUsedError;
  String get instruction => throw _privateConstructorUsedError;
  set instruction(String value) => throw _privateConstructorUsedError;
  String? get lessonType => throw _privateConstructorUsedError;
  set lessonType(String? value) => throw _privateConstructorUsedError;
  String? get lessonUrl => throw _privateConstructorUsedError;
  set lessonUrl(String? value) => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  set isDownloaded(bool value) => throw _privateConstructorUsedError;
  DownloadModel? get downloadModel => throw _privateConstructorUsedError;
  set downloadModel(DownloadModel? value) => throw _privateConstructorUsedError;

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
      bool isDownloaded,
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
    Object? isDownloaded = null,
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
      isDownloaded: null == isDownloaded
          ? _value.isDownloaded
          : isDownloaded // ignore: cast_nullable_to_non_nullable
              as bool,
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
      bool isDownloaded,
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
    Object? isDownloaded = null,
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
      isDownloaded: null == isDownloaded
          ? _value.isDownloaded
          : isDownloaded // ignore: cast_nullable_to_non_nullable
              as bool,
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
  _$LessonImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.instruction,
      this.lessonType,
      this.lessonUrl,
      this.isDownloaded = false,
      this.downloadModel})
      : super._();

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  int id;
  @override
  String title;
  @override
  String description;
  @override
  String instruction;
  @override
  String? lessonType;
  @override
  String? lessonUrl;
  @override
  @JsonKey()
  bool isDownloaded;
  @override
  DownloadModel? downloadModel;

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, description: $description, instruction: $instruction, lessonType: $lessonType, lessonUrl: $lessonUrl, isDownloaded: $isDownloaded, downloadModel: $downloadModel)';
  }

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
  factory _Lesson(
      {required int id,
      required String title,
      required String description,
      required String instruction,
      String? lessonType,
      String? lessonUrl,
      bool isDownloaded,
      DownloadModel? downloadModel}) = _$LessonImpl;
  const _Lesson._() : super._();

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  int get id;
  set id(int value);
  @override
  String get title;
  set title(String value);
  @override
  String get description;
  set description(String value);
  @override
  String get instruction;
  set instruction(String value);
  @override
  String? get lessonType;
  set lessonType(String? value);
  @override
  String? get lessonUrl;
  set lessonUrl(String? value);
  @override
  bool get isDownloaded;
  set isDownloaded(bool value);
  @override
  DownloadModel? get downloadModel;
  set downloadModel(DownloadModel? value);
  @override
  @JsonKey(ignore: true)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

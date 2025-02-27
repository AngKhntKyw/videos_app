// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'instruction': instance.instruction,
      'lessonType': instance.lessonType,
      'lessonUrl': instance.lessonUrl,
      'isDownloaded': instance.isDownloaded,
      'downloadModel': instance.downloadModel?.toJson(),
    };

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      instruction: json['instruction'] as String,
      lessonType: json['lessonType'] as String?,
      lessonUrl: json['lessonUrl'] as String?,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      downloadModel: json['downloadModel'] == null
          ? null
          : DownloadModel.fromJson(
              json['downloadModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'instruction': instance.instruction,
      'lessonType': instance.lessonType,
      'lessonUrl': instance.lessonUrl,
      'isDownloaded': instance.isDownloaded,
      'downloadModel': instance.downloadModel,
    };

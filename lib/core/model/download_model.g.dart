// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DownloadModelImpl _$$DownloadModelImplFromJson(Map<String, dynamic> json) =>
    _$DownloadModelImpl(
      id: (json['id'] as num?)?.toInt(),
      courseId: (json['courseId'] as num?)?.toInt(),
      lessonId: (json['lessonId'] as num?)?.toInt(),
      courseTitle: json['courseTitle'] as String?,
      url: json['url'] as String?,
      lessonTitle: json['lessonTitle'] as String?,
      path: json['path'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      status: $enumDecodeNullable(_$DownloadStatusEnumMap, json['status']) ??
          DownloadStatus.none,
    );

Map<String, dynamic> _$$DownloadModelImplToJson(_$DownloadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lessonId': instance.lessonId,
      'courseTitle': instance.courseTitle,
      'url': instance.url,
      'lessonTitle': instance.lessonTitle,
      'path': instance.path,
      'downloadUrl': instance.downloadUrl,
      'progress': instance.progress,
      'status': _$DownloadStatusEnumMap[instance.status],
    };

const _$DownloadStatusEnumMap = {
  DownloadStatus.none: 'none',
  DownloadStatus.waiting: 'waiting',
  DownloadStatus.running: 'running',
  DownloadStatus.success: 'success',
  DownloadStatus.fail: 'fail',
};

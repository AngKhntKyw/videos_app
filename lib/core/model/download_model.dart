import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:videos_app/core/model/lesson.dart';
part 'download_model.freezed.dart';
part 'download_model.g.dart';

@unfreezed
class DownloadModel with _$DownloadModel {
  const DownloadModel._();

  factory DownloadModel({
    int? id,
    int? courseId,
    int? lessonId,
    String? courseTitle,
    String? url,
    String? lessonTitle,
    String? path,
    String? downloadUrl,
    double? progress,
    @Default(DownloadStatus.none) DownloadStatus? status,
  }) = _DownloadModel;

  factory DownloadModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadModelFromJson(json);
}

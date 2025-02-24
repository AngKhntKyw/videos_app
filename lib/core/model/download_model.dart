import 'package:freezed_annotation/freezed_annotation.dart';
part 'download_model.freezed.dart';
part 'download_model.g.dart';

@freezed
class DownloadModel with _$DownloadModel {
  const DownloadModel._();

  const factory DownloadModel({
    int? id,
    int? courseId,
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

enum DownloadStatus {
  none,
  waiting,
  running,
  success,
  fail,
}

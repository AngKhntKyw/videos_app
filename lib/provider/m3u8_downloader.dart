// m3u8_downloader.dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class M3U8Downloader {
  double totalDuration = 0;
  int? sessionId;

  static M3U8Downloader instance = M3U8Downloader._();
  factory M3U8Downloader() => instance;

  M3U8Downloader._();

  Future<String?> download({
    required String url,
    required String lessonTitle,
    Function(double)? onProgress,
  }) async {
    String fileName = await getSavePath(lessonTitle);
    final cmd = '-i $url -c:v mpeg4 $fileName -y';

    Completer<String?> completer = Completer();

    await FFmpegKit.executeAsync(
      cmd,
      (Session session) async {
        final returnCode = await session.getReturnCode();
        log('Data: failStackTrace ${await session.getFailStackTrace()}');
        if (ReturnCode.isSuccess(returnCode)) {
          log("Data: SUCCESS Download success");
          completer.complete(fileName);
        } else if (ReturnCode.isCancel(returnCode)) {
          log('Data: CANCEL $returnCode');
          completer.complete(null);
        } else {
          log('Data: ERROR ${await session.getLogsAsString()}');
          completer.complete(null);
        }
      },
      (Log l) {
        sessionId = l.getSessionId();
        RegExp timePattern = RegExp(r'^\d{2}:\d{2}:\d{2}\.\d{2}$');
        String line = l.getMessage();

        if (timePattern.hasMatch(line)) {
          List<String> durationParts = line.split(':');
          totalDuration = double.parse(durationParts[0]) * 3600 +
              double.parse(durationParts[1]) * 60 +
              double.parse(durationParts[2]);
        }

        if (line.startsWith('frame=') && totalDuration > 0) {
          String time = line.split('time=')[1].split(' ')[0];
          List<String> timeParts = time.split(':');
          double currentTime = double.parse(timeParts[0]) * 3600 +
              double.parse(timeParts[1]) * 60 +
              double.parse(timeParts[2]);
          double progressPercentage =
              (currentTime / totalDuration).clamp(0.0, 1.0);
          onProgress?.call(progressPercentage);
        }
      },
    );

    return completer.future;
  }

  Future<String> getSavePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    String dirPath = dir.path;
    final fn = fileName
        .replaceAll(' ', '_')
        .toLowerCase()
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final file = File('$dirPath${path.separator}$fn.mp4');
    return file.path;
  }
}

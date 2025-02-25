import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class M3U8Downloader {
  double totalDuration = 0;
  int? sessionId;

  static M3U8Downloader instance = M3U8Downloader._();
  factory M3U8Downloader() {
    return instance;
  }

  M3U8Downloader._();

  void download(
      {required String url,
      required String lessonTitle,
      void Function(dynamic msg)? onSuccess,
      required void Function(int sessionId) onStart,
      void Function(dynamic err)? onError,
      void Function(dynamic progress)? onProgress}) {
    final String cmd = '-i $url -c:v mpeg4 $lessonTitle -y';
    log('downloading : ---');
    FFmpegKit.executeAsync(
      cmd,
      (session) async {
        sessionId = session.getSessionId();
        log('Data: session $sessionId');
        onStart.call(sessionId ?? 0);

        final returnCode = await session.getReturnCode();
        log('Data: failStackTrace ${await session.getFailStackTrace()}');
        if (ReturnCode.isSuccess(returnCode)) {
          // SUCCESS
          log('Success');
          onSuccess?.call(
              {"status": 2, "url": url, "filePath": lessonTitle, "dir": ''});
        } else if (ReturnCode.isCancel(returnCode)) {
          // CANCEL
          log('Data: Cancel $returnCode');
          delete(lessonTitle);
          onError?.call({
            "status": 3,
            "url": url,
            "filePath": lessonTitle,
          });
        } else {
          // ERROR
          log('Data: ERROR ${await session.getLogsAsString()}');
          delete(lessonTitle);
          onError?.call({
            "status": 3,
            "url": url,
            "filePath": lessonTitle,
          });
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

        if (line.startsWith('frame=')) {
          String time = line.split('time=')[1].split(' ')[0];
          List<String> timeParts = time.split(':');
          double currentTime = double.parse(timeParts[0]) * 3600 +
              double.parse(timeParts[1]) * 60 +
              double.parse(timeParts[2]);

          double progressPercentage =
              ((currentTime / totalDuration) * 100) / 100;
          log('progressPercentage : $progressPercentage');

          onProgress?.call({
            "status": 1,
            "url": url,
            "filePath": lessonTitle,
            "progress": progressPercentage
          });
        }
      },
    );
  }

  void cancel() async {
    log('Session Id : $sessionId');
    await FFmpegKit.cancel(sessionId);
  }

  Future<bool> delete(String title) async {
    try {
      final dir = await getInternalStorageDirectory();
      final fn = title.replaceAll(' ', '_').toLowerCase();
      File f = File('$dir${p.separator}$fn.mp4');
      log('Delete : ${f.path}');
      if (f.existsSync()) {
        f.deleteSync();
        return true;
      }
    } catch (e) {
      log("Can't Delete $e");
      return false;
    }
    log("Can't Delete ");
    return false;
  }

  Future<String> getSavePath(String fileName) async {
    final dir = await getInternalStorageDirectory();
    final fn = fileName
        .replaceAll(' ', '_')
        .toLowerCase()
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '');

    final file = File('$dir${p.separator}$fn.mp4');
    return file.path;
  }

  Future<String> getInternalStorageDirectory() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    } catch (e) {
      log('Error getting internal storage directory: $e');
      throw Exception('Error getting internal storage directory: $e');
    }
  }

  bool isRunning() {
    log('Running : ${sessionId != null}');
    return sessionId != null;
  }
}

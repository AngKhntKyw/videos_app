import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/download_task_provider.dart';

class DownloadDelete extends StatefulWidget {
  final int unitIdx;
  final int lessonIdx;
  const DownloadDelete(
      {super.key, required this.lessonIdx, required this.unitIdx});

  @override
  State<DownloadDelete> createState() => _DownloadDeleteState();
}

class _DownloadDeleteState extends State<DownloadDelete> {
  @override
  Widget build(BuildContext context) {
    final lesson = context.select<CourseProvider, Lesson>((p) =>
        p.currentCourse!.units[widget.unitIdx].lessons[widget.lessonIdx]);
    context.watch<CourseProvider>();
    return InkWell(
      onTap: () async {
        // download or delete
        if (lesson.downloadModel!.status == DownloadStatus.none) {
          final downloadModel = lesson.downloadModel!;
          downloadModel.url = lesson.lessonUrl!;

          context
              .read<DownloadTaskProvider>()
              .startDownload(downloadModel, context);
        }

        if (lesson.downloadModel!.status == DownloadStatus.success) {
          final state = context.read<DownloadTaskProvider>();
          final bool isWatching = context
              .read<CourseProvider>()
              .isLessonWatching(lessonId: lesson.id);
          if (isWatching) {
            await infoToUser();
          } else {
            final result = await confirmUser();
            if (result != null) {
              if (result) {
                // if path == null , video path  will be remote URl

                lesson.downloadModel?.progress = 0;
                lesson.downloadModel?.lessonTitle = lesson.title;
                final result = await state.delete(
                        lesson.lessonUrl!, lesson.downloadModel!, lesson.id) ??
                    false;
                lesson.downloadModel?.path = null;
                if (result && mounted) {
                  log("delete success");
                }
              }
            }
          }
        }
      },
      child: Stack(
        children: [
          if (lesson.downloadModel!.status == DownloadStatus.running) ...{
            CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.black,
              color: Colors.grey,
              value: lesson.downloadModel!.progress != 0.0
                  ? lesson.downloadModel!.progress
                  : null,
            )
          },
          CircleAvatar(
              backgroundColor: Colors.transparent,
              child: DownloadStatusPage(status: lesson.downloadModel!.status!)),
        ],
      ),
    );
  }

  Future<bool?> confirmUser() async {
    return await showDialog<bool>(
        context: context,
        builder: (b) {
          return AlertDialog(
            title: const Text("Delete"),
            content: Text(
              "Are you sure want to delete this lesson!",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.black),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Delete")),
            ],
          );
        });
  }

  Future<bool?> infoToUser() async {
    return await showDialog<bool>(
        context: context,
        builder: (b) {
          return AlertDialog(
            title: const Text("Can't Delete"),
            content: Text(
              "Lesson is playing now!",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.black),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close")),
            ],
          );
        });
  }
}

class DownloadStatusPage extends StatelessWidget {
  final DownloadStatus status;
  const DownloadStatusPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // log('$kTAG ${status.name}');
    switch (status) {
      case DownloadStatus.running:
        return const Text("");
      case DownloadStatus.success:
        return const Icon(Icons.delete);
      case DownloadStatus.fail:
        return const Text("");
      case DownloadStatus.waiting:
        return const Icon(Icons.stop);
      case DownloadStatus.none:
        return const Icon(Icons.download);
      default:
        return const Text("");
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:videos_app/core/model/lesson.dart';
// import 'package:videos_app/provider/course_provider.dart';

// class DownloadDelete extends StatefulWidget {
//   final int unitIdx;
//   final int lessonIdx;
//   const DownloadDelete({
//     super.key,
//     required this.lessonIdx,
//     required this.unitIdx,
//   });

//   @override
//   State<DownloadDelete> createState() => _DownloadDeleteState();
// }

// class _DownloadDeleteState extends State<DownloadDelete> {
//   @override
//   Widget build(BuildContext context) {
//     //
//     final lesson = context.select<CourseProvider, Lesson>((p) =>
//         p.currentCourse!.units[widget.unitIdx].lessons[widget.lessonIdx]);

//     //
//     return TextButton(
//       onPressed: () {
//         context.read<CourseProvider>().createDownloadModelInLocalStorage(
//             downloadModel: esson.downloadModel!);
//       },
//       child: Text(lesson.downloadModel!.status!.name),
//     );
//   }
// }

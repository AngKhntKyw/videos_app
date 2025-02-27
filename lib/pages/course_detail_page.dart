// import 'dart:developer';
// import 'dart:io';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:videos_app/core/model/course.dart';
// import 'package:videos_app/core/model/download_model.dart';
// import 'package:videos_app/core/model/lesson.dart';
// import 'package:videos_app/provider/course_provider.dart';

// class CourseDetailPage extends StatefulWidget {
//   final Course course;
//   const CourseDetailPage({super.key, required this.course});

//   @override
//   State<CourseDetailPage> createState() => _CourseDetailPageState();
// }

// class _CourseDetailPageState extends State<CourseDetailPage> with RouteAware {
//   // Better Player
//   final GlobalKey<BetterPlayerPlaylistState> betterPlayerPlaylistStateKey =
//       GlobalKey();
//   BetterPlayerPlaylistController? get getKey =>
//       betterPlayerPlaylistStateKey.currentState!.betterPlayerPlaylistController;
//   late BetterPlayerConfiguration betterPlayerConfiguration;
//   late BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;

//   //

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) {
//         context
//             .read<CourseProvider>()
//             .setUpVideoDataSource(course: widget.course);
//       },
//     );
//     initBetterPlayer();
//     super.initState();
//   }

//   @override
//   void didPop() async {
//     log("Did pop");
//     context.read<CourseProvider>().clearDataSources();
//     await getKey?.betterPlayerController!.clearCache();
//     await getKey?.betterPlayerController!.videoPlayerController!.dispose();
//     getKey?.betterPlayerController!.dispose(forceDispose: true);
//     getKey?.dispose();
//     super.didPop();
//   }

//   void initBetterPlayer() {
//     final courseProvider = context.read<CourseProvider>();
//     betterPlayerConfiguration = BetterPlayerConfiguration(
//       controlsConfiguration: const BetterPlayerControlsConfiguration(
//         progressBarHandleColor: Colors.green,
//         progressBarBackgroundColor: Colors.white,
//         progressBarBufferedColor: Colors.grey,
//         progressBarPlayedColor: Colors.green,
//         enableMute: true,
//         iconsColor: Colors.white,
//       ),
//       autoPlay: false,
//       fit: BoxFit.contain,
//       autoDetectFullscreenDeviceOrientation: true,
//       autoDetectFullscreenAspectRatio: true,
//       fullScreenByDefault: false,
//       autoDispose: true,
//       aspectRatio: 16 / 9,
//       fullScreenAspectRatio: 16 / 9,
//       handleLifecycle: true,

//       //
//       eventListener: (event) async {
//         switch (event.betterPlayerEventType) {
//           case BetterPlayerEventType.setupDataSource:
//             break;

//           case BetterPlayerEventType.initialized:
//             getKey?.betterPlayerController!.setControlsVisibility(false);
//             // Uncomment to auto-play if desired
//             // await getKey?.betterPlayerController!.play();
//             break;

//           case BetterPlayerEventType.changedTrack:
//             if (!mounted) return;
//             await getKey?.betterPlayerController!.clearCache();

//             if (getKey!.currentDataSourceIndex != 0) {
//               final lesson = courseProvider.findLessonByDataSourceIndex(
//                 index: getKey?.currentDataSourceIndex,
//               );
//               log("Changed track to ${lesson.title}, index: ${getKey!.currentDataSourceIndex}");
//               courseProvider.setWatchingLesson(lesson: lesson);

//               final aspectRatio = getKey?.betterPlayerController!
//                   .videoPlayerController!.value.aspectRatio;
//               getKey?.betterPlayerController!
//                   .setOverriddenAspectRatio(aspectRatio!);
//             }
//             break;

//           case BetterPlayerEventType.progress:
//             if (!mounted) return;
//             break;

//           case BetterPlayerEventType.finished:
//             await getKey?.betterPlayerController!.clearCache();
//             // Reset watching lesson when finished
//             break;

//           default:
//             break;
//         }
//       },
//     );

//     betterPlayerPlaylistConfiguration = const BetterPlayerPlaylistConfiguration(
//       loopVideos: false,
//       nextVideoDelay: Duration(seconds: 5),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final courseProvider = context.watch<CourseProvider>();

//     return Scaffold(
//       appBar: AppBar(),
//       body: courseProvider.currentCourse == null
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 BetterPlayerPlaylist(
//                   betterPlayerConfiguration: betterPlayerConfiguration,
//                   key: betterPlayerPlaylistStateKey,
//                   betterPlayerDataSourceList: courseProvider.dataSourceList,
//                   betterPlayerPlaylistConfiguration:
//                       betterPlayerPlaylistConfiguration,
//                 ),

//                 //
//                 Expanded(
//                   child: ListView.builder(
//                     physics: const ClampingScrollPhysics(),
//                     addAutomaticKeepAlives: false,
//                     addRepaintBoundaries: false,
//                     addSemanticIndexes: false,
//                     itemCount: courseProvider.currentCourse!.units.length,
//                     itemBuilder: (context, index) {
//                       return ExpansionTile(
//                         childrenPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                         shape: const ContinuousRectangleBorder(
//                             side: BorderSide(color: Colors.grey, width: 0)),
//                         controlAffinity: ListTileControlAffinity.trailing,
//                         enableFeedback: true,
//                         expansionAnimationStyle: AnimationStyle(
//                           curve: Curves.easeInOut,
//                           reverseCurve: Curves.easeInOut,
//                         ),
//                         dense: true,
//                         title: Text(
//                             courseProvider.currentCourse!.units[index].name),
//                         subtitle: Text(
//                             "${courseProvider.currentCourse!.units[index].lessons.length} lessons"),
//                         onExpansionChanged: (value) {},
//                         children: [
//                           //
//                           ListView.builder(
//                             addAutomaticKeepAlives: false,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: courseProvider
//                                 .currentCourse!.units[index].lessons.length,
//                             itemBuilder: (context, lessonIndex) {
//                               Lesson currentLesson = courseProvider
//                                   .currentCourse!
//                                   .units[index]
//                                   .lessons[lessonIndex];

//                               //

//                               return ListTile(
//                                 dense: true,
//                                 onTap: () async {
//                                   if (currentLesson.lessonUrl != null) {
//                                     await getKey?.betterPlayerController!
//                                         .clearCache();
//                                     final download = courseProvider
//                                         .getDownloadModelForLesson(
//                                             currentLesson);
//                                     final index = courseProvider
//                                         .findDataSourceIndexByLesson(
//                                             lesson: currentLesson);
//                                     log("Index for ${currentLesson.title}: $index");

//                                     // Set the current lesson as watching before playback
//                                     courseProvider.setWatchingLesson(
//                                         lesson: currentLesson);

//                                     if (index == -1) {
//                                       log("Invalid index, refreshing data source list");
//                                       courseProvider.dataSourceList.clear();
//                                       courseProvider.dataSourceList.add(
//                                           courseProvider.createDataSource(
//                                               courseProvider
//                                                   .currentCourse!.introVideoUrl,
//                                               null));
//                                       for (var lesson
//                                           in courseProvider.videoLessons) {
//                                         courseProvider.dataSourceList.add(
//                                             courseProvider.createDataSource(
//                                                 lesson.lessonUrl, lesson));
//                                       }
//                                       final newIndex = courseProvider
//                                           .findDataSourceIndexByLesson(
//                                               lesson: currentLesson);
//                                       log("New index after refresh: $newIndex");
//                                       if (newIndex != -1) {
//                                         getKey?.setupDataSource(newIndex);
//                                       } else {
//                                         log("Still no valid index for ${currentLesson.title}");
//                                         return;
//                                       }
//                                     } else {
//                                       if (download!.path != null &&
//                                           download.status ==
//                                               DownloadStatus.success) {
//                                         final file = File(download.path!);
//                                         if (await file.exists()) {
//                                           log("Playing local file: ${download.path}");
//                                         } else {
//                                           log("Local file not found: ${download.path}");
//                                           courseProvider
//                                               .queueForDownload(currentLesson);
//                                           return;
//                                         }
//                                       } else {
//                                         log("No local file, streaming from: ${currentLesson.lessonUrl}");
//                                       }
//                                       try {
//                                         getKey?.setupDataSource(index);
//                                       } catch (e) {
//                                         log("Playback error: $e");
//                                       }
//                                     }
//                                   } else {
//                                     log("Lesson URL : null");
//                                   }
//                                 },
//                                 leading: Consumer<CourseProvider>(
//                                   builder: (context, provider, child) {
//                                     return provider.isLessonWatching(
//                                             lessonId: currentLesson.id)
//                                         ? const Icon(Icons.pause_circle,
//                                             color: Colors.green)
//                                         : const Icon(Icons.play_circle);
//                                   },
//                                 ),
//                                 title: Text(currentLesson.title),
//                                 subtitle: Text(currentLesson.description,
//                                     maxLines: 2),
//                                 trailing: Consumer<CourseProvider>(
//                                   builder: (context, provider, child) {
//                                     final download =
//                                         provider.getDownloadModelForLesson(
//                                             currentLesson);
//                                     return Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         _buildDownloadStatus(
//                                             currentLesson, provider, download!),
//                                         _buildDownloadButton(
//                                             currentLesson, provider, download),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 //
//               ],
//             ),
//     );
//   }
// }

// Widget _buildDownloadStatus(
//     Lesson lesson, CourseProvider provider, DownloadModel download) {
//   switch (download.status) {
//     case DownloadStatus.waiting:
//     case DownloadStatus.running:
//       return SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           value: download.progress,
//         ),
//       );
//     case DownloadStatus.success:
//       return const Icon(Icons.check_circle, color: Colors.green);
//     case DownloadStatus.fail:
//       return const Icon(Icons.error, color: Colors.red);
//     case DownloadStatus.none:
//     default:
//       return const SizedBox.shrink();
//   }
// }

// Widget _buildDownloadButton(
//     Lesson lesson, CourseProvider provider, DownloadModel download) {
//   Widget icon;
//   bool isEnabled = true;

//   switch (download.status) {
//     case DownloadStatus.waiting:
//       icon = const Icon(Icons.hourglass_empty);
//       break;
//     case DownloadStatus.running:
//       icon = const Icon(Icons.downloading_rounded);
//       break;
//     case DownloadStatus.success:
//       icon = const Icon(Icons.download_done);
//       isEnabled = false;
//       break;
//     case DownloadStatus.fail:
//       icon = const Icon(Icons.error_outline);
//       break;
//     case DownloadStatus.none:
//     default:
//       icon = const Icon(Icons.file_download_outlined);
//       break;
//   }

//   return IconButton(
//     onPressed: isEnabled ? () => provider.queueForDownload(lesson) : null,
//     icon: icon,
//   );
// }

import 'dart:developer';
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/course_provider.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> with RouteAware {
  // Better Player
  final GlobalKey<BetterPlayerPlaylistState> betterPlayerPlaylistStateKey =
      GlobalKey();
  BetterPlayerPlaylistController? get getKey =>
      betterPlayerPlaylistStateKey.currentState!.betterPlayerPlaylistController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;

  //

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context
            .read<CourseProvider>()
            .setUpVideoDataSource(course: widget.course);
      },
    );
    initBetterPlayer();
    super.initState();
  }

  @override
  void didPop() async {
    log("Did pop");
    context.read<CourseProvider>().clearDataSources();
    await getKey?.betterPlayerController!.clearCache();
    await getKey?.betterPlayerController!.videoPlayerController!.dispose();
    getKey?.betterPlayerController!.dispose(forceDispose: true);
    getKey?.dispose();
    super.didPop();
  }

  void initBetterPlayer() {
    final courseProvider = context.read<CourseProvider>();
    betterPlayerConfiguration = BetterPlayerConfiguration(
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        progressBarHandleColor: Colors.green,
        progressBarBackgroundColor: Colors.white,
        progressBarBufferedColor: Colors.grey,
        progressBarPlayedColor: Colors.green,
        enableMute: true,
        iconsColor: Colors.white,
      ),
      autoPlay: false,
      fit: BoxFit.contain,
      autoDetectFullscreenDeviceOrientation: true,
      autoDetectFullscreenAspectRatio: true,
      fullScreenByDefault: false,
      autoDispose: true,
      aspectRatio: 16 / 9,
      fullScreenAspectRatio: 16 / 9,
      handleLifecycle: true,
      eventListener: (event) async {
        switch (event.betterPlayerEventType) {
          //
          case BetterPlayerEventType.setupDataSource:

            // resetTimer();
            break;

          case BetterPlayerEventType.initialized:
            getKey?.betterPlayerController!.setControlsVisibility(false);
            // await getKey?.betterPlayerController!.play();
            break;

          case BetterPlayerEventType.changedTrack:
            if (!mounted) return;
            await getKey?.betterPlayerController!.clearCache();

            if (getKey!.currentDataSourceIndex != 0) {
              final lesson = courseProvider.findLessonByDataSourceIndex(
                index: getKey?.currentDataSourceIndex,
              );
              courseProvider.setWatchingLesson(lesson: lesson);

              final aspectRatio = getKey?.betterPlayerController!
                  .videoPlayerController!.value.aspectRatio;

              getKey?.betterPlayerController!
                  .setOverriddenAspectRatio(aspectRatio!);
            }
            break;

          case BetterPlayerEventType.progress:
            if (!mounted) return;
            break;

          case BetterPlayerEventType.finished:
            await getKey?.betterPlayerController!.clearCache();
            break;

          default:
            break;
        }
      },
    );

    betterPlayerPlaylistConfiguration = const BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: courseProvider.currentCourse == null
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BetterPlayerPlaylist(
                  betterPlayerConfiguration: betterPlayerConfiguration,
                  key: betterPlayerPlaylistStateKey,
                  betterPlayerDataSourceList: courseProvider.dataSourceList,
                  betterPlayerPlaylistConfiguration:
                      betterPlayerPlaylistConfiguration,
                ),

                //
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    addSemanticIndexes: false,
                    itemCount: courseProvider.currentCourse!.units.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        childrenPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        shape: const ContinuousRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 0)),
                        controlAffinity: ListTileControlAffinity.trailing,
                        enableFeedback: true,
                        expansionAnimationStyle: AnimationStyle(
                          curve: Curves.easeInOut,
                          reverseCurve: Curves.easeInOut,
                        ),
                        dense: true,
                        title: Text(
                            courseProvider.currentCourse!.units[index].name),
                        subtitle: Text(
                            "${courseProvider.currentCourse!.units[index].lessons.length} lessons"),
                        onExpansionChanged: (value) {},
                        children: [
                          //
                          ListView.builder(
                            addAutomaticKeepAlives: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: courseProvider
                                .currentCourse!.units[index].lessons.length,
                            itemBuilder: (context, lessonIndex) {
                              Lesson currentLesson = courseProvider
                                  .currentCourse!
                                  .units[index]
                                  .lessons[lessonIndex];

                              //

                              return ListTile(
                                dense: true,
                                onTap: () async {
                                  if (currentLesson.lessonUrl != null) {
                                    await getKey?.betterPlayerController!
                                        .clearCache();
                                    final download = courseProvider
                                        .getDownloadModelForLesson(
                                            currentLesson);
                                    final index = courseProvider
                                        .findDataSourceIndexByLesson(
                                            lesson: currentLesson);
                                    log("Index for ${currentLesson.title}: $index");

                                    if (index == -1) {
                                      log("Invalid index, refreshing data source list");

                                      courseProvider.dataSourceList.clear();
                                      courseProvider.dataSourceList.add(
                                          courseProvider.createDataSource(
                                              courseProvider
                                                  .currentCourse!.introVideoUrl,
                                              null));
                                      for (var lesson
                                          in courseProvider.videoLessons) {
                                        courseProvider.dataSourceList.add(
                                            courseProvider.createDataSource(
                                                lesson.lessonUrl, lesson));
                                      }
                                      final newIndex = courseProvider
                                          .findDataSourceIndexByLesson(
                                              lesson: currentLesson);
                                      log("New index after refresh: $newIndex");
                                      if (newIndex != -1) {
                                        getKey?.setupDataSource(index);
                                      } else {
                                        log("Still no valid index for ${currentLesson.title}");
                                        return;
                                      }
                                    } else {
                                      if (download!.path != null &&
                                          download.status ==
                                              DownloadStatus.success) {
                                        final file = File(download.path!);
                                        if (await file.exists()) {
                                          log("Playing local file: ${download.path}");
                                        } else {
                                          log("Local file not found: ${download.path}");
                                          courseProvider
                                              .queueForDownload(currentLesson);
                                          return;
                                        }
                                      } else {
                                        log("No local file, streaming from: ${currentLesson.lessonUrl}");
                                      }
                                      try {
                                        getKey?.setupDataSource(index);
                                      } catch (e) {
                                        log("Playback error: $e");
                                      }
                                    }
                                  } else {
                                    log("Lesson URL : null");
                                  }
                                },
                                leading: courseProvider.isLessonWatching(
                                        lessonId: currentLesson.id)
                                    ? const Icon(Icons.pause_circle,
                                        color: Colors.green)
                                    : const Icon(Icons.play_circle),
                                title: Text(currentLesson.title),
                                subtitle: Text(currentLesson.description,
                                    maxLines: 2),
                                trailing: Consumer<CourseProvider>(
                                  builder: (context, provider, child) {
                                    final download =
                                        provider.getDownloadModelForLesson(
                                            currentLesson);
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildDownloadStatus(
                                            currentLesson, provider, download!),
                                        _buildDownloadButton(
                                            currentLesson, provider, download),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                //
              ],
            ),
    );
  }
}

Widget _buildDownloadStatus(
    Lesson lesson, CourseProvider provider, DownloadModel download) {
  switch (download.status) {
    case DownloadStatus.waiting:
    case DownloadStatus.running:
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: download.progress,
        ),
      );
    case DownloadStatus.success:
      return const Icon(Icons.check_circle, color: Colors.green);
    case DownloadStatus.fail:
      return const Icon(Icons.error, color: Colors.red);
    case DownloadStatus.none:
    default:
      return const SizedBox.shrink();
  }
}

Widget _buildDownloadButton(
    Lesson lesson, CourseProvider provider, DownloadModel download) {
  IconData icon;
  bool isEnabled = true;

  switch (download.status) {
    case DownloadStatus.waiting:
      icon = Icons.hourglass_empty;
      break;
    case DownloadStatus.running:
      icon = Icons.downloading;
      break;
    case DownloadStatus.success:
      icon = Icons.download_done;
      isEnabled = false;
      break;
    case DownloadStatus.fail:
      icon = Icons.error_outline;
      break;
    case DownloadStatus.none:
    default:
      icon = Icons.file_download_outlined;
      break;
  }

  return IconButton(
    onPressed: isEnabled ? () => provider.queueForDownload(lesson) : null,
    icon: Icon(icon),
  );
}

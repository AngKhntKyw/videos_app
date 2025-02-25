import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/core/model/lesson.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/download_task_provider.dart';
import 'package:videos_app/widgets/download_delete_widget.dart';

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
    context.read<CourseProvider>().setUpVideoDataSource(course: widget.course);
    initBetterPlayer();
    super.initState();
  }

  @override
  void didPop() async {
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
            await getKey?.betterPlayerController!.play();
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
      appBar: AppBar(title: Text(courseProvider.currentCourse!.title)),
      body: Column(
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
              itemCount: widget.course.units.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: const ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  enableFeedback: true,
                  expansionAnimationStyle: AnimationStyle(
                    curve: Curves.easeInOut,
                    reverseCurve: Curves.easeInOut,
                  ),
                  dense: true,
                  title: Text(widget.course.units[index].name),
                  subtitle: Text(
                      "${widget.course.units[index].lessons.length} lessons"),
                  onExpansionChanged: (value) {},
                  children: [
                    //
                    ListView.builder(
                      addAutomaticKeepAlives: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.course.units[index].lessons.length,
                      itemBuilder: (context, lessonIndex) {
                        Lesson currentLesson =
                            widget.course.units[index].lessons[lessonIndex];

                        //
                        return ListTile(
                          dense: true,
                          onTap: () async {
                            if (currentLesson.lessonUrl != null) {
                              await getKey?.betterPlayerController!
                                  .clearCache();
                              getKey?.setupDataSource(
                                courseProvider.findDataSourceIndexByLesson(
                                    lesson: currentLesson),
                              );
                            } else {
                              log("Lesson URL : null");
                            }
                          },
                          leading: courseProvider.isLessonWatching(
                                  lessonId: currentLesson.id)
                              ? const Icon(
                                  Icons.pause_circle,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.play_circle),
                          title: Text(currentLesson.title),
                          subtitle:
                              Text(currentLesson.description, maxLines: 2),
                          trailing: DownloadDelete(
                            unitIdx: widget.course.units
                                .indexOf(widget.course.units[index]),
                            lessonIdx: widget.course.units[index].lessons
                                .indexOf(currentLesson),
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

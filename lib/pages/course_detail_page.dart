import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/course.dart';
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
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.white),
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
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: widget.course.units.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                  maintainState: false,
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.course.units[index].lessons.length,
                      itemBuilder: (context, lessonIndex) {
                        Lesson currentLesson =
                            widget.course.units[index].lessons[lessonIndex];

                        //
                        return ListTile(
                          dense: true,
                          leading: courseProvider.isLessonWatching(
                                  lessonId: currentLesson.id)
                              ? const Icon(Icons.pause_circle)
                              : const Icon(Icons.play_circle),
                          title: Text(
                            currentLesson.title,
                          ),
                          subtitle: Text(
                            currentLesson.description,
                            maxLines: 2,
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.file_download_outlined),
                          ),
                          onTap: () async {
                            final courseProvider =
                                context.read<CourseProvider>();

                            await getKey?.betterPlayerController!.clearCache();

                            getKey?.setupDataSource(
                              courseProvider.findDataSourceIndexByLesson(
                                lesson: currentLesson,
                              ),
                            );

                            courseProvider.setWatchingLesson(
                              lesson: currentLesson,
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void initBetterPlayer() {
    final courseProvider = context.read<CourseProvider>();

    //
    betterPlayerConfiguration = BetterPlayerConfiguration(
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        progressBarHandleColor: Color(0xff227143),
        progressBarBackgroundColor: Colors.white,
        progressBarBufferedColor: Colors.grey,
        progressBarPlayedColor: Color(0xff227143),
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
          case BetterPlayerEventType.setupDataSource:
            break;

          case BetterPlayerEventType.initialized:
            getKey?.betterPlayerController!.setControlsVisibility(false);
            await getKey?.betterPlayerController!.play();
            getKey!.currentDataSourceIndex != 0
                ? courseProvider.setWatchingLesson(
                    lesson: courseProvider.findLessonByDataSourceIndex(
                      index: getKey?.currentDataSourceIndex,
                    ),
                  )
                : null;
            break;

          case BetterPlayerEventType.changedTrack:
            if (!mounted) return;
            await getKey?.betterPlayerController!.clearCache();

            break;

          case BetterPlayerEventType.changedSubtitles:
            await getKey?.betterPlayerController!.clearCache();
            break;

          case BetterPlayerEventType.progress:
            break;

          case BetterPlayerEventType.finished:
            await getKey?.betterPlayerController!.clearCache();
          default:
            break;
        }
      },
    );

    betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: const Duration(seconds: 5),
      initialStartIndex: context.read<CourseProvider>().getLastWatchingLesson(),
    );
  }
}

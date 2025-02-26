import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/navigation_bar_page.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/database_helper.dart';
import 'package:videos_app/provider/download_task_provider.dart';

void main() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => DownloadTaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Videos App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const NavigationBarPage(),
      ),
    );
  }
}

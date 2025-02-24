import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/pages/home_page.dart';
import 'package:videos_app/provider/course_provider.dart';
import 'package:videos_app/provider/download_task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => DownloadTaskProvider(
            CourseProvider(),
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

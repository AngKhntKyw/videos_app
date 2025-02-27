import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/provider/course_provider.dart';

class LocalDatabasePage extends StatefulWidget {
  const LocalDatabasePage({super.key});

  @override
  State<LocalDatabasePage> createState() => _LocalDatabasePageState();
}

class _LocalDatabasePageState extends State<LocalDatabasePage> {
  @override
  Widget build(BuildContext context) {
    final courseProvider = context.read<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Database"),
        actions: [
          IconButton(
              onPressed: () {
                courseProvider.deleteLocallDatabase();
                setState(() {});
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: FutureBuilder(
        future: courseProvider.getLocalDownloads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("data not found"));
          }

          final downloads = snapshot.data!;
          //
          return ListView.builder(
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              DownloadModel download = downloads[index];

              //
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  child: Text(download.courseId!.toString()),
                ),
                title: Text(download.lessonTitle!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Downeload Id ${download.id}"),
                    Text("Download Url : ${download.downloadUrl!}"),
                    Text("Path : ${download.path}"),
                    Text("Status : ${download.status!.name}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

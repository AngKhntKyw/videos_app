import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videos_app/core/model/download_model.dart';
import 'package:videos_app/provider/database_helper.dart';

class LocalDatabasePage extends StatefulWidget {
  const LocalDatabasePage({super.key});

  @override
  State<LocalDatabasePage> createState() => _LocalDatabasePageState();
}

class _LocalDatabasePageState extends State<LocalDatabasePage> {
  final DatabaseHelper db = GetIt.instance.get<DatabaseHelper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Database"),
      ),
      body: FutureBuilder(
        future: db.getDownloads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          List<DownloadModel> downloads = snapshot.data!;

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

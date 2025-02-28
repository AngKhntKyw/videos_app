import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:videos_app/core/model/course.dart';
import 'package:videos_app/course/course.dart';
import 'package:videos_app/pages/course_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;
  @override
  Widget build(BuildContext context) {
    List<Course> courses =
        courseListJson.map((json) => Course.fromJson(json)).toList();

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                {
                  setState(() {
                    isGridView = !isGridView;
                  });
                }
              },
              icon: Icon(isGridView ? Icons.list_alt_sharp : Icons.grid_on))
        ],
      ),
      body: isGridView
          ? GridView.builder(
              itemCount: courses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GridViewCourseCard(
                  course: courses[index],
                );
              },
            )
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListViewCourseCard(
                  course: courses[index],
                );
              },
            ),
    );
  }
}

class ListViewCourseCard extends StatelessWidget {
  final Course course;
  const ListViewCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 219, 239, 220),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height / 6,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: course.imgUrl,
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width / 3,
              height: double.infinity,
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width / 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        course.description,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "${course.price}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridViewCourseCard extends StatelessWidget {
  final Course course;
  const GridViewCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 219, 239, 220),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  imageUrl: course.imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${course.price}",
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

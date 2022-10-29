import 'dart:io';
import 'package:courses/Course.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart';
import 'GetxController.dart';

class Course extends StatefulWidget {
  List<PlatformFile>? file;
  ValueChanged<PlatformFile>? onopenedfile;

  Course({this.file, this.onopenedfile});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  getxcontroller controller = Get.find();
  late Future<ListResult> futureFile;

  @override
  void initState() {
    futureFile = FirebaseStorage.instance
        .ref("video/course ${Constants.titleofcourse}")
        .listAll();
    print(
        "${FirebaseStorage.instance.ref("video/course ${Constants.titleofcourse}")}=============================");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Course"),
        ),
        body: GetBuilder<getxcontroller>(
          init: getxcontroller(),
          builder: (getxcontroller) => FutureBuilder<ListResult>(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final files = snapshot.data!.items;
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return ListTile(
                      title: Text("Video ${index}"),
                      // subtitle: Text(file.name),
                      onTap: () async {
                        Constants.vidurlvew = [];
                        Constants.vidurlvew.add(await file.getDownloadURL());
                        controller.initialnow();
                        Get.toNamed("/Video");
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Error");
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            future: futureFile,
          ),
        ));
  }
}

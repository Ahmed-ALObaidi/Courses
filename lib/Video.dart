import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart';
import 'GetxController.dart';

class Video extends StatefulWidget {
  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  getxcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (controller.controllerr.value.isPlaying) {
                controller.controllerr.pause();
              } else {
                controller.controllerr.play();
              }
            });
          },
          child: Icon(
            controller.controllerr.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        appBar: AppBar(
          title: Text("Video"),
        ),
        body: Center(
          child: FutureBuilder(
            future: controller.controllerr.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: controller.controllerr.value.aspectRatio,
                  child: VideoPlayer(controller.controllerr),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}

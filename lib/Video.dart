import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart';
import 'GetxController.dart';
class Video extends StatefulWidget{
  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  getxcontroller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Text("test"),
        ),
        body:
        ListView(
          children: [
            GetBuilder<getxcontroller>(
                init: getxcontroller(),
                builder:(controller) =>
                    Container(
                      width: double.infinity,
                      height: 500,
                      child: Constants.vidurlvew.isEmpty ? const Center(child: Text("dont find image "),) :
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return
                            Center(
                                child: AspectRatio(aspectRatio: controller.controllerr.value.aspectRatio,
                                    child: Card(child: VideoPlayer(controller.controllerr)))
                            );
                        },itemCount: Constants.vidurlvew.length,),
                    )
            )

          ],
        )
    );
  }
}
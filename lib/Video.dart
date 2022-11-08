// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:video_player/video_player.dart';
// import 'Constants.dart';
// import 'GetxController.dart';
//
// class Video extends StatefulWidget {
//   @override
//   State<Video> createState() => _VideoState();
// }
//
// class _VideoState extends State<Video> {
//   getxcontroller controller = Get.find();
//
//   @override
//   void initState() {
//     controller.controllerr.initialize();
//     controller.controllerr.pause();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controller.controllerr.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Video"),
//         ),
//         body: ListView(children: [
//           Center(
//             child: FutureBuilder(
//               future: controller.controllerr.initialize(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Center(
//                     child: AspectRatio(
//                       aspectRatio: 3,
//                       // controller.controllerr.value.aspectRatio,
//                       child: Center(child: VideoPlayer(controller.controllerr)),
//                     ),
//                   );
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//           IntrinsicHeight(
//             child: Row(
//               children: [
//                 ElevatedButton(
//                     onPressed: () async {
//                       setState(() {});
//                       Duration? value =  await controller.controllerr.position;
//                       var d = value! - Duration(seconds: 3);
//                       controller.controllerr.seekTo(Duration(seconds: d.inSeconds));
//                     },
//                     child: Text("<<")),
//                 ElevatedButton(
//                     onPressed: () {
//                       setState(() {});
//                       controller.controllerr.pause();
//                     },
//                     child: Icon(Icons.pause)),
//                 ElevatedButton(
//                     onPressed: () {
//                       setState(() {});
//                       controller.controllerr.pause();
//                     },
//                     child: Icon(Icons.play_arrow_rounded)),
//                 ElevatedButton(
//                     onPressed: () async {
//                       setState(() {});
//                       Duration? value =  await controller.controllerr.position;
//                       var d = Duration(seconds: 3)+value!;
//                       controller.controllerr.seekTo(Duration(seconds: d.inSeconds));
//                     },
//                     child: Text(">>")),
//               ],
//             ),
//           )
//         ]));
//   }
// }



import 'dart:io';

import 'package:courses/Constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import 'GetxController.dart';


class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController AssetController;
  late VideoPlayerController fileController;
  late VideoPlayerController networkController;
  bool isMute = false;
  getxcontroller controller = Get.find();
  String vURL = Constants.vidurlvew[Constants.vidurlvew.length - 1];
  @override
  void initState() {
    super.initState();
      networkController= VideoPlayerController.network(vURL)
        ..initialize().then((value) {setState(() {});});
    // AssetController = VideoPlayerController.asset("assets/abc.mp4")
    //   ..initialize().then((_) {
    //
    //     setState(() {});
    //   });

    // fileController = VideoPlayerController.file(new File(""))
    //   ..initialize().then((value) {
    //     fileController.play();
    //     setState(() {
    //
    //     });
    //   });
  }
  // Future<File?> pickFile() async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.video);
  //   if( result ==null)
  //     return null;
  //   return File(result.files.single.path.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Video Player App"),
        ),
        body: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text("From Asset" ,style: TextStyle(fontSize: 30),),
            // ),
            // buildVideoPlayer(AssetController),
            SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("My Course", style: TextStyle(fontSize: 30),),
            ),
            buildVideoPlayer(networkController),
            SizedBox(height: 20,),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text("From File", style: TextStyle(fontSize: 30),),
            // ),
            // buildVideoPlayer(fileController),

            // ElevatedButton(onPressed: () async{
            //   final file = await pickFile();
            //   if (file ==null) return ;
            //   else {
            //     fileController = VideoPlayerController.file(file)
            //       ..initialize().then((_) {
            //         fileController.play();
            //         setState(() {});
            //       });
            //   }
            //
            // }, child: Text("Pick a File")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            setState(() {
              networkController.setVolume(isMute?1:0);
              isMute =!isMute;
            });
            // controller.mute(networkController);
          },
          child: Icon(
            isMute? Icons.volume_off_rounded : Icons.volume_up,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      );
  }
  buildVideoPlayer(VideoPlayerController Controller)
  {
    return Column(
      children: [
        Center(
          child: Controller.value.isInitialized?
          AspectRatio(aspectRatio: Controller.value.aspectRatio, child: VideoPlayer(Controller),)
              : Center(child: CircularProgressIndicator(),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: ()async{
                  // Duration? value =  await Controller.position;
                  // var d = value! - Duration(seconds: 10);
                  // Controller.seekTo(Duration(seconds: d.inSeconds));
                  controller.beforetenminute(Controller);
                }, child: Text("<<")),
            ElevatedButton(
              child: Icon(Icons.play_arrow_rounded),
              onPressed: (){
                Controller.play();
              },),
            ElevatedButton(
              child: Icon(Icons.pause_outlined),
              onPressed: (){
                Controller.pause();
              }, ),
            ElevatedButton(onPressed:  ()async {
              // Duration? value =  await Controller.position;
              // var d = Duration(seconds: 10)+value!;
              // Controller.seekTo(Duration(seconds: d.inSeconds));
              controller.aftertenminute(Controller);
            }, child: Text(">>")),

          ],
        )
      ],
    );
  }

//   @override
//   void dispose() {
//     super.dispose();
//     AssetController.dispose();
//     networkController.dispose();
//     fileController.dispose();
//   }

}

import 'dart:io';
import 'dart:math';
import 'package:courses/Course.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'Loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';
import 'package:image_picker/image_picker.dart';
class AddCourses extends StatefulWidget{
  @override
  State<AddCourses> createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
  getxcontroller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("AddCourses"),
        actions: [
          IconButton(onPressed: () {Get.offNamed("/Home");}, icon: Icon(Icons.backpack_rounded))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: controller.formstate,
          child: ListView(children: [
            SizedBox(height: 300,),
            Text("If you want to add a Course we need some information about this course : "),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(hintText: "Title of the Course : ",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if(value!.length < 2){
                  return "The Title is too small.";
                }
                else {
                  Constants.title = value;
                }
              },
              onSaved: (newValue) {
                Constants.title = newValue!;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(hintText: "Description of the Course : ",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if(value!.length < 2){
                  return "The Description is too small.";
                }
                else {
                  Constants.description = value;
                }
              },
              onSaved: (newValue) {
                Constants.description = newValue!;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(hintText: "Contents of Course : ",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if(value!.length < 2){
                  return "The Contents is too small.";
                }
                else {
                  Constants.content = value;
                }
              },
              onSaved: (newValue) {
                Constants.content = newValue!;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(hintText: "The Price of the Course : ",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if(value!.length < 2){
                  return "The Price is too small.";
                }
                else {
                  Constants.price = value;
                }
              },
              onSaved: (newValue) {
                Constants.price = newValue!;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(hintText: "Duration of the Course : ",border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if(value!.length < 2){
                  return "The Duration is too small.";
                }
                else {
                  Constants.duration = value;
                }
              },
              onSaved: (newValue) {
                Constants.duration = newValue!;
              },
            ),
            SizedBox(height: 20,),
            GetBuilder<getxcontroller>(
              init: getxcontroller(),
              builder:(controller) =>  ElevatedButton(onPressed: () async {
                await controller.uploadinfo();
              }, child: Text("upload information")),
            ),

            SizedBox(height: 20,),
            GetBuilder<getxcontroller>(
              init: getxcontroller(),
              builder:(controller) =>  ElevatedButton(onPressed: () async {
                await controller.selectfile();
              }, child: Text("select files")),
            ),

            GetBuilder<getxcontroller>(
              init: getxcontroller(),
              builder:(controller) =>  ElevatedButton(onPressed: () async {
                await controller.uploadcourse();
                getxcontroller.controll = [];
                for(int a=0;a<getxcontroller.pathesofvid.length;a++){
                  await controller.initialize(getxcontroller.pathesofvid[a]);
                  print("${getxcontroller.pathesofvid[a]} ======================================================== URL VIDEO");
                }
                getxcontroller.share!.setString("id", "1");
                // Get.toNamed("/Course");
                getxcontroller.listcourse = await FirebaseStorage.instance.ref("video").listAll().then((value) => value.prefixes.length);
                Get.offNamed("/Home");
              }, child: Text("upload files")),
            ),
          ],),
        ),
      ),
    );
  }
}

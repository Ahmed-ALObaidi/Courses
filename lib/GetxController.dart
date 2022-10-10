import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/AddCourses.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class getxcontroller extends GetxController{
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  static PlatformFile? pickedFile;
  List<PlatformFile>? pickedFiles;
  static List<File> filesup = [];
  static List<String> pathesofvid =[];
  static late List<VideoPlayerController> controll;
  static SharedPreferences? share;
  static var listcourse ;
  static var cont;
  var controllerr;
  BottomNavigationBaronTap(value){
    Constants.currentIndex = value ;
    update();
  }
  selectfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(result == null)return;
    pickedFiles = result.files;
    pickedFile = result.files.first;
    update();
  }
  uploadcourse() async {
    if(pickedFiles != null){
      pickedFiles!.forEach((element) {
        filesup.add(File(element.path!));
      });
      // Constants.file = File(pickedFile!.path!);
      // var rand = Random(999999999);
      // var vidname = basename("${rand}${pickedFile!.path}");
      // print("$vidname ============================================= name of video");
      // var vidref = await FirebaseStorage.instance.ref("video/course ${Constants.title}/${Constants.vidid++}$vidname");
      // await vidref.putFile(Constants.file!);
      // // UploadTask vidfile = (await vidref.putFile(Constants.file!)) as UploadTask;
      // // vidfile.whenComplete(() => {});
      // var url = await vidref.getDownloadURL();
      // Constants.vidurl =await url.toString();
      // print("======================================================================");
      // print("${Constants.vidurl!} ================================== URL OF VIDEO ");
      // 5555555555555555555555555555555555555555555555555
      Constants.courses = [];
      for(int a=0; a< filesup.length ; a++){
        var rand = Random(999999999);
         Constants.vidname = basename("${rand}${filesup[a].path}");
        print("${ Constants.vidname} ============================================= name of video");
        var vidref = await FirebaseStorage.instance.ref("video/course ${Constants.title}/${Constants.vidid++}${Constants.vidname}");
        await vidref.putFile(filesup[a]);
        var url = await vidref.getDownloadURL();
        Constants.vidurl =await url.toString();
        pathesofvid.add(Constants.vidurl);
        print("======================================================================");
        print("${Constants.vidurl!} ================================== URL OF VIDEO ");
        print("${pathesofvid} ================================== URL OF VIDEO ");
      }
      update();
    }else{
      return "Select a Video";
    }

    update();
  }

  deletecourse( String coursename , String id)async{
    var elm;
    var list1 = [];
    var url;
    var strurl;
    var ref1;
    await FirebaseStorage.instance.ref()
        .child("$coursename")
        .listAll()
        .then((value) => value.items.forEach((element) {
      elm = element.name;
      list1.add(elm);
    }));
    for (int a =0 ; a<list1.length ; a++){
      ref1 =  await FirebaseStorage.instance.ref("$coursename/${list1[a]}");
      url = await ref1.getDownloadURL();
      strurl = await url.toString();
      await FirebaseStorage.instance.refFromURL(strurl).delete();
    }
    final collection = FirebaseFirestore.instance.collection('courses');
    collection
        .doc('$id')
        .delete()
        .then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
    update();
  }

  favoritecourse(){
    if(Constants.favoritecourse1.contains("${Constants.fcourse0}")){
      Constants.favoritecourse1.remove(Constants.fcourse0);
      print("TRUE++++++++++++++++++++++++++++");
    }else{
      Constants.favoritecourse1.add(Constants.fcourse0);
      print("FALSE---------------------------------");
    }
    print("${Constants.favoritecourse1} favorite list ****************");
    print("${Constants.fcourse0} NOOOOOOOOOOTT favorite list ****************");
    update();
  }
  initialnow()async{
    controllerr = await VideoPlayerController.network(Constants.vidurlvew[Constants.vidurlvew.length - 1]);
    controllerr..addListener(() { })..notifyListeners()..initialize().then((value) => controllerr.play());
    update();
  }
  initialize(String videoUrl,) async {
       cont = await VideoPlayerController.network(videoUrl)..addListener(() { })
        ..notifyListeners()
        ..setLooping(false);
      controll.add(cont);
      cont.initialize().then((value) => controll[controll.length - 1].play());
      update();
    update();
  }

  uploadinfo() async {
    var formdata = formstate.currentState;
    if(formdata!.validate()){
      await FirebaseFirestore.instance.collection("courses").add({
        "title":Constants.title,
        "description":Constants.description,
        "duration":Constants.duration,
        "contents":Constants.content,
        "price":Constants.price,
        "Time":DateTime.now(),
        "favorite" : 0,
        "userid" : FirebaseAuth.instance.currentUser!.uid,
      });
      print("=====================done======================");
    } else {
      return "Not Valid";
    }
    update();
  }

  mockfetch(List list)async{
    if(Constants.allloaded)return;
    Constants.loading = true;
    await Future.delayed(Duration(milliseconds: 500));
    List newData = list.length >= 3 ? [] : List.generate(3, (index) => index+list.length);
    if(newData.isNotEmpty){
      list.addAll(list);
    }
    else{
      Constants.loading = false;
      Constants.allloaded = newData.isEmpty;
    }
    update();
  }

  uploadeimg() async {
    var imgpicked = await Constants.picked.pickImage(source: ImageSource.gallery,);
    if(imgpicked != null){
      Constants.file = File(imgpicked.path);
      var rand = Random(999999999);
      var imgname = basename("${rand}${imgpicked.path}");
      print("$imgname ============================================= name of image");
      await FirebaseStorage.instance.ref("images/$imgname").putFile(Constants.file!);
      Constants.imgurl = await FirebaseStorage.instance.ref("images/$imgname").getDownloadURL();
      print("${Constants.imgurl!} ================================== ");
    }else{
      return "Select an image";
    }
    update();
  }
  changelocale(String localecode){
    share?.setString("lang", localecode);
    Locale locale = Locale(localecode);
    Get.updateLocale(locale);
  }

  late ThemeData themeData = share?.getString("theme") == "dark" ? ThemeData.dark() : ThemeData.light();
  changetheme(){
    if(Get.isDarkMode){
      share?.setString("theme", "light");
      Get.changeTheme(ThemeData.light());
    }else {
      share?.setString("theme", "dark");
      Get.changeTheme(ThemeData.dark());
    }
    update();
  }

  late Locale initial = share?.getString("lang") == null ? Get.deviceLocale! : Locale(share!.getString("lang")!) ;
  ////////////////////////////////////////////////////////////////////////////////////////////////
  List items = [];
  bool isloading = false ;
  bool hasmoredata = true ;
  void getData() async {
    if(!isloading && hasmoredata){
      isloading = true;
      update();
      await Future.delayed(Duration(seconds: 1));
      List dummydata = items.length > 3 ? [] : List.generate(3,(index) => "index : ${index + items.length}");
      if(dummydata.isEmpty){
        hasmoredata = false;
      }
      dummydata.addAll(dummydata);
      isloading = false;
      update();
    }
  }




}
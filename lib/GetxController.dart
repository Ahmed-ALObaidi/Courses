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

class getxcontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  static PlatformFile? pickedFile;
  List<PlatformFile>? pickedFiles;
  static List<File> filesup = [];
  static List<String> pathesofvid = [];
  static late List<VideoPlayerController> controll;
  static SharedPreferences? share;
  static var listcourse;

  static var cont;
  late VideoPlayerController controllerr;
  var listofstream;
  static var profileimageurl;
  static String name = "";

  BottomNavigationBaronTap(value) {
    Constants.currentIndex = value;
    update();
  }

  setBoolValue(bool myval) {
    Constants.isExcuted = myval;
    print("Done22222==========================");
    update();
  }

  changePass(String pass) async {
    var doc_id;
    print("--------------------------------------");
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .update({"pass": "${pass}"});
    await FirebaseAuth.instance.currentUser!.updatePassword(pass);
    print("============================================");
    Get.offNamed("/Account");
  }

  changeEmail(String email) async {
    var doc_id;
    print("--------------------------------------");
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .update({"email": "${email}"});
    await FirebaseAuth.instance.currentUser!.updateEmail(email);
    print("============================================");
    Get.offNamed("/Account");
    // where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed("/SignUP");
  }

  Stream<QuerySnapshot<Object?>> streambuild() async* {
    print("${getxcontroller.name}nnnnnnnnnnnnnnnnnnnnnnnnname");
    // if(getxcontroller.name != null && getxcontroller.name != ""){
    //  yield* FirebaseFirestore.instance.collection("courses")
    //       .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //       .where("title",isEqualTo: getxcontroller.name).snapshots();
    // }else {
    //   yield* FirebaseFirestore.instance.collection("courses")
    //       .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
    // }
    yield* FirebaseFirestore.instance
        .collection("courses")
        .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("title",
            isGreaterThanOrEqualTo: getxcontroller.name,
            isLessThan: getxcontroller.name + 'z')
        .snapshots();
    update();
  }

  Stream<QuerySnapshot> stream() async* {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var firestore = FirebaseFirestore.instance;
    // var _stream = firestore.collection(currentUser!.uid).snapshots();
    var _stream = firestore
        .collection("courses")
        .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    update();
    yield* _stream;
    update();
  }

  void requestNextPage() async {
    print("${Constants.products}*++++++++++++++++++++++++***");
    if (!Constants.isRequesting && !Constants.isFinish) {
      QuerySnapshot querySnapshot;
      Constants.isRequesting = true;
      if (Constants.products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('courses')
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('title')
            .limit(5)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('courses')
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('title')
            .startAfterDocument(
                Constants.products[Constants.products.length - 1])
            .limit(5)
            .get();
      }
      if (querySnapshot != null) {
        int oldSize = Constants.products.length;
        Constants.products.addAll(querySnapshot.docs);
        int newSize = Constants.products.length;
        if (oldSize != newSize) {
          Constants.streamController.add(Constants.products);
          // if(Constants.streamController.isClosed){
          //   Constants.streamController.add(Constants.products);
          // }
        } else {
          Constants.isFinish = true;
        }
      }
      Constants.isRequesting = false;
    }
    update();
  }

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        Constants.products.removeWhere(
          (product) => productChange.doc.id == product.id,
        );
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = Constants.products.indexWhere(
            (product) => productChange.doc.id == product.id,
          );
          if (indexWhere >= 0) {
            Constants.products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });
    if (isChange) {
      if (!Constants.streamController.isClosed) {
        Constants.streamController.add(Constants.products);
      }
    }
    update();
  }

  Stream<QuerySnapshot> searchData(String string) async* {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var firestore = FirebaseFirestore.instance;
    var _search = firestore
        // .collection(currentUser!.uid)
        .collection("courses")
        .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('title', isGreaterThanOrEqualTo: string)
        .where('title', isLessThan: string + 'z')
        .snapshots();
    update();
    yield* _search;
    update();
  }

  streamlist() {
    if (name != null && name != "") {
      listofstream = FirebaseFirestore.instance
          .collection("courses")
          .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('title', isGreaterThanOrEqualTo: name)
          .where('title', isLessThan: name + 'z')
          .snapshots();
      update();
      return listofstream;
    } else {
      listofstream = FirebaseFirestore.instance
          .collection("courses")
          .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      update();
      return listofstream;
    }
  }

  selectfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    pickedFiles = result.files;
    pickedFile = result.files.first;
    update();
  }

  uploadcourse() async {
    if (pickedFiles != null) {
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
      for (int a = 0; a < filesup.length; a++) {
        var rand = Random(999999999);
        Constants.vidname = basename("${rand}${filesup[a].path}");
        print(
            "${Constants.vidname} ============================================= name of video");
        var vidref = await FirebaseStorage.instance.ref(
            "video/course ${Constants.title}/${Constants.vidid++}${Constants.vidname}");
        await vidref.putFile(filesup[a]);
        var url = await vidref.getDownloadURL();
        Constants.vidurl = await url.toString();
        pathesofvid.add(Constants.vidurl);
        print(
            "======================================================================");
        print(
            "${Constants.vidurl!} ================================== URL OF VIDEO ");
        print(
            "${pathesofvid} ================================== URL OF VIDEO ");
      }
      update();
    } else {
      return "Select a Video";
    }

    update();
  }

  deletecourse(String coursename, String id) async {
    var elm;
    var list1 = [];
    var url;
    var strurl;
    var ref1;
    await FirebaseStorage.instance
        .ref()
        .child("$coursename")
        .listAll()
        .then((value) => value.items.forEach((element) {
              elm = element.name;
              list1.add(elm);
            }));
    for (int a = 0; a < list1.length; a++) {
      ref1 = await FirebaseStorage.instance.ref("$coursename/${list1[a]}");
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

  initialnow() async {
    controllerr = await VideoPlayerController.network(
        Constants.vidurlvew[Constants.vidurlvew.length - 1]);
    controllerr
      ..addListener(() {})
      ..notifyListeners()
      ..initialize().then((value) => controllerr.play());
    update();
  }

  initialize(
    String videoUrl,
  ) async {
    cont = await VideoPlayerController.network(videoUrl)
      ..addListener(() {})
      ..notifyListeners()
      ..setLooping(false);
    controll.add(cont);
    cont.initialize().then((value) => controll[controll.length - 1].play());
    update();
    update();
  }

  uploadinfo() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      await FirebaseFirestore.instance.collection("courses").add({
        "title": Constants.title,
        "description": Constants.description,
        "duration": Constants.duration,
        "contents": Constants.content,
        "price": Constants.price,
        "Time": DateTime.now(),
        "favorite": 0,
        "userid": FirebaseAuth.instance.currentUser!.uid,
      });
      print("=====================done======================");
    } else {
      return "Not Valid";
    }
    update();
  }

  Future newgetdata(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future newquerydata(String queryString) async {
    update();
    return await FirebaseFirestore.instance
        .collection("courses")
        .where("title",
            isGreaterThanOrEqualTo: queryString, isLessThan: queryString + 'z')
        .get();
  }

  Imgfromgalary() async {
    var username;
    var doc_id;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .get()
        .then((value) {
      username = value.get("username");
    });
    var imgpicked = await Constants.picked.pickImage(
      source: ImageSource.gallery,
    );
    if (imgpicked != null) {
      Constants.file = File(imgpicked.path);
      var rand = Random(999999999);
      var imgname = basename("${rand}${imgpicked.path}");
      print(
          "$imgname ============================================= name of image");
      await FirebaseStorage.instance
          .ref("images/$username/$imgname")
          .putFile(Constants.file!);
      Constants.imgurl = await FirebaseStorage.instance
          .ref("images/$username/$imgname")
          .getDownloadURL();
      print("${Constants.imgurl!} ================================== ");
    } else {
      return "Select an image";
    }
    Constants.uploadedimg = true;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .update({"Imageurl": "${Constants.imgurl}"});
    update();
  }

  profilePictureurl() async {
    var doc_id;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .get()
        .then((value) {
      profileimageurl = value.get("Imageurl");
    });
    print("**${profileimageurl}--------------------------------------****");
    // yield* profileimageurl;
    update();
  }

  deleteprofilepic() async {
    ////////////////////////////////////////////////
    // var elm;
    // var list1 = [];
    // var url;
    // var strurl;
    // var ref1;
    // await FirebaseStorage.instance.ref()
    //     .child("$coursename")
    //     .listAll()
    //     .then((value) => value.items.forEach((element) {
    //   elm = element.name;
    //   list1.add(elm);
    // }));
    // for (int a =0 ; a<list1.length ; a++){
    //   ref1 =  await FirebaseStorage.instance.ref("$coursename/${list1[a]}");
    //   url = await ref1.getDownloadURL();
    //   strurl = await url.toString();
    //   await FirebaseStorage.instance.refFromURL(strurl).delete();
    // }
    ////////////////////////////////////////////////////////////////////
    late var username;
    var doc_id;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .get()
        .then((value) {
      username = value.get("Imageurl");
    });
    print("${username}/**********************-----------------------/");
    // ref1 = FirebaseStorage.instance.ref('images/${username}');
    // ref2 = await ref1.getDownloadURL();
    // strref2 = ref2.toString();
    // print("${strref2}TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    await FirebaseStorage.instance.refFromURL(username).delete();
    // // FirebaseStorage.instance.refFromURL(strref2).delete();
    // print("DDOONNEEE#######################################3");

    // await FirebaseFirestore.instance.collection("users").doc(doc_id).get().then((value) {username = value.get("Imageurl"); });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .update({"Imageurl": ""});
    update();
  }

  Imgfromcamera() async {
    var imgpicked = await Constants.picked.pickImage(
      source: ImageSource.camera,
    );
    if (imgpicked != null) {
      Constants.file = File(imgpicked.path);
      var rand = Random(999999999);
      var imgname = basename("${rand}${imgpicked.path}");
      print(
          "$imgname ============================================= name of image");
      await FirebaseStorage.instance
          .ref("images/$imgname")
          .putFile(Constants.file!);
      Constants.imgurl = await FirebaseStorage.instance
          .ref("images/$imgname")
          .getDownloadURL();
      print("${Constants.imgurl!} ================================== ");
    } else {
      return "Select an image";
    }
    Constants.uploadedimg = true;
    var doc_id;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        doc_id = element.id;
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(doc_id)
        .update({"Imageurl": "${Constants.imgurl}"});
    update();
  }

  late Locale initial = share?.getString("lang") == null
      ? Get.deviceLocale!
      : Locale(share!.getString("lang")!);

  changelocale(String localecode) {
    share?.setString("lang", localecode);
    Locale locale = Locale(localecode);
    Get.updateLocale(locale);
  }

  late ThemeData themeData = share?.getString("theme") == "dark"
      ? ThemeData.dark()
      : ThemeData.light();

  changetheme() {
    if (Get.isDarkMode) {
      share?.setString("theme", "light");
      Get.changeTheme(ThemeData.light());
    } else {
      share?.setString("theme", "dark");
      Get.changeTheme(ThemeData.dark());
    }
    update();
  }

  List items = [];
  bool isloading = false;

  bool hasmoredata = true;

  void getData() async {
    if (!isloading && hasmoredata) {
      isloading = true;
      update();
      await Future.delayed(Duration(seconds: 1));
      List dummydata = items.length > 3
          ? []
          : List.generate(3, (index) => "index : ${index + items.length}");
      if (dummydata.isEmpty) {
        hasmoredata = false;
      }
      dummydata.addAll(dummydata);
      isloading = false;
      update();
    }
  }
}

import 'package:courses/Account.dart';
import 'package:courses/AddCourses.dart';
import 'package:courses/Constants.dart';
import 'package:courses/Favorite.dart';
import 'package:courses/HomePage.dart';
import 'package:courses/Search.dart';
import 'package:courses/SignIn.dart';
import 'package:courses/SignUP.dart';
import 'package:courses/Course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangeEmail.dart';
import 'ChangePassword.dart';
import 'Constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'GetxController.dart';
import 'Locale.dart';
import 'Home.dart';
import 'Video.dart';
import 'ChangeName.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getxcontroller.share = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  getxcontroller.listcourse = await FirebaseStorage.instance
      .ref("video")
      .listAll()
      .then((value) => value.prefixes.length);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  getxcontroller controller = Get.put(getxcontroller());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LangLocale(),
      locale: controller.initial,
      theme: controller.themeData,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "/SignUP" : "/Home",
      getPages: [
        GetPage(name: "/Home", page: () => Home()),
        GetPage(name: "/Course", page: () => Course()),
        GetPage(name: "/AddCourses", page: () => AddCourses()),
        GetPage(name: "/HomePage", page: () => HomePage()),
        GetPage(name: "/ChangeName", page: () => ChangeName()),
        GetPage(name: "/Account", page: () => Account()),
        GetPage(name: "/Search", page: () => Search()),
        GetPage(name: "/SignIn", page: () => SignIn()),
        GetPage(name: "/SignUP", page: () => SignUP()),
        GetPage(name: "/Favorite", page: () => Favorite()),
        GetPage(name: "/Video", page: () => Video()),
        GetPage(name: "/ChangePassword", page: () => ChangePassword()),
        GetPage(name: "/ChangeEmail", page: () => ChangeEmail()),
      ],
    );
  }
}

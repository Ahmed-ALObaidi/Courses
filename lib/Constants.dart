import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static int currentIndex = 0;
  static late List pages;
  static List courses = [];
  static var usernameup;
  static var emailup;
  static bool uploadedimg = false;
  static var passup;
  static var phone;
  static var fname;
  static List<DocumentSnapshot> products = [];
  static var lname;
  static bool isRequesting = false;
  static bool isFinish = false;

  static StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  static late bool isExcuted = false;
  static var title;
  static var description;
  static var duration;
  static var content;
  static var price;
  static ImagePicker picked = ImagePicker();
  static File? file;
  static var imgurl;
  static var vidurl;
  static var titleofcourse;
  static int vidid = 0;
  static int top5id = 0;
  static List vidurlvew = [];
  static var firstcourse;
  static var lastcourse;
  static int courseid = 0;
  static String fcourse0 = "";
  static Set favoritecourse1 = Set();

  static var vidname;
  static bool loading = false, allloaded = false;
}

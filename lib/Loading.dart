import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Laoding {
  static showloading(context){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(title: Text("Loading"),content: Text("Content"),);
    },
    );
  }
}
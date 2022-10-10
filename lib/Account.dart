import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';
class Account extends StatelessWidget{
  getxcontroller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Text("Account"),
        ),
        body: ListView(
          children: [
          SizedBox(height: 30,),
          GetBuilder<getxcontroller>(
            init: getxcontroller(),
            builder:(controller) =>
                CircleAvatar(minRadius: 100,)
          ),
            SizedBox(height: 30,),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Text("Change Language : "),
                ElevatedButton(onPressed: () {
                  controller.changelocale("ar");
                }, child: Text("AR")),
                ElevatedButton(onPressed: () {
                  controller.changelocale("en");
                }, child: Text("EN")),
              ],),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Change Mode : "),
                  ElevatedButton(onPressed: () {
                    controller.changetheme();
                  }, child: Text("Change mode")),
                ],),
            ),
        ],),
    );
  }

}
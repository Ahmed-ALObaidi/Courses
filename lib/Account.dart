import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  getxcontroller controller = Get.find();

  @override
  void initState() {
    controller.printaccountusername();
    controller.printaccountfname();
    controller.printaccountlname();
    controller.printaccountemail();
    print("${controller.id()}56666666666666665");
  controller.profilePictureurl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          GetBuilder<getxcontroller>(
              init: getxcontroller(),
              builder: (controller) =>
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 100,
                          backgroundImage:
                          getxcontroller.profileimageurl == null
                              ? null
                              : NetworkImage(
                              '${getxcontroller.profileimageurl}'),
                          child: getxcontroller.profileimageurl == null
                              ? const Icon(
                            Icons.person,
                            size: 100,
                          )
                              : null),
                      IconButton(
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: const Text("From Camera"),
                                      leading: const Icon(Icons.camera),
                                      onTap: () {
                                        controller.Imgfromcamera();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      title: const Text("From Gallary"),
                                      leading: const Icon(Icons.storage),
                                      onTap: () {
                                        controller.Imgfromgalary();
                                        // Get.offNamed("/Account");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      title: const Text("Delete Picture"),
                                      leading: const Icon(Icons.delete),
                                      onTap: () {
                                        controller.deleteprofilepic();
                                        // Get.offNamed("/Account");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.camera_alt)),
                    ],
                  )),
          const SizedBox(
            height: 30,
          ),



          IntrinsicHeight(
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
              Text("USER NAME : "),
              GetBuilder<getxcontroller>(builder: (controller) {
                return Center(child: Text("${controller.accountusername}" , style: TextStyle(fontSize: 18),));

              },init: getxcontroller(),),
            ],),
          ),


          IntrinsicHeight(
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
              Text("First NAME : "),
              GetBuilder<getxcontroller>(builder: (controller) {
                return Center(child: Text("${controller.accountfname}" , style: TextStyle(fontSize: 18),));

              },init: getxcontroller(),),
            ],),
          ),


          IntrinsicHeight(
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
              Text("LAST NAME : "),
              GetBuilder<getxcontroller>(builder: (controller) {
                return Center(child: Text("${controller.accountlname}" , style: TextStyle(fontSize: 18),));

              },init: getxcontroller(),),
            ],),
          ),


          IntrinsicHeight(
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("EMAIL : "),
              GetBuilder<getxcontroller>(builder: (controller) {
                return Center(child: Text("${controller.accountemail}" , style: TextStyle(fontSize: 18),));

              },init: getxcontroller(),),
            ],),
          ),

          IntrinsicHeight(
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("NAME : "),
              GetBuilder<getxcontroller>(builder: (controller) {
                return Center(child: Text("${controller.accountusername}" , style: TextStyle(fontSize: 18),));
              },init: getxcontroller(),),
            ],),
          ),

          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Change Language : "),
                ElevatedButton(
                    onPressed: () {
                      controller.changelocale("ar");
                    },
                    child: const Text("AR")),
                ElevatedButton(
                    onPressed: () {
                      controller.changelocale("en");
                    },
                    child: const Text("EN")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Change Mode : "),
                ElevatedButton(
                    onPressed: () {
                      controller.changetheme();
                    },
                    child: const Text("Change mode")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Sign out : "),
                ElevatedButton(
                    onPressed: () {
                      controller.signout();
                    },
                    child: const Text("out")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Change Password : "),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/ChangePassword");
                    },
                    child: const Text("change")),
              ],
            ),
          ),

          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Change NAME : "),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/ChangeName");
                    },
                    child: const Text("change")),
              ],
            ),
          ),


          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Change Email : "),
                ElevatedButton(
                    onPressed: () async {
                      Get.toNamed("/ChangeEmail");
                    },
                    child: const Text("change")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

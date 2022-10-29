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
    controller.profilePictureurl();
    super.initState();
    print("++++++++++++${getxcontroller.profileimageurl}+++++++++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          GetBuilder<getxcontroller>(
              init: getxcontroller(),
              builder: (controller) => Row(
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
                                      title: Text("From Camera"),
                                      leading: Icon(Icons.camera),
                                      onTap: () {
                                        controller.Imgfromcamera();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      title: Text("From Gallary"),
                                      leading: Icon(Icons.storage),
                                      onTap: () {
                                        controller.Imgfromgalary();
                                        // Get.offNamed("/Account");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Delete Picture"),
                                      leading: Icon(Icons.delete),
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
          SizedBox(
            height: 30,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Change Language : "),
                ElevatedButton(
                    onPressed: () {
                      controller.changelocale("ar");
                    },
                    child: Text("AR")),
                ElevatedButton(
                    onPressed: () {
                      controller.changelocale("en");
                    },
                    child: Text("EN")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Change Mode : "),
                ElevatedButton(
                    onPressed: () {
                      controller.changetheme();
                    },
                    child: Text("Change mode")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Sign out : "),
                ElevatedButton(
                    onPressed: () {
                      controller.signout();
                    },
                    child: Text("out")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Change Password : "),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/ChangePassword");
                    },
                    child: Text("change")),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Change Email : "),
                ElevatedButton(
                    onPressed: () async {
                      Get.toNamed("/ChangeEmail");
                    },
                    child: Text("change")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

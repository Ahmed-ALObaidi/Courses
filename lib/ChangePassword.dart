import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';

class ChangePassword extends StatelessWidget {
  getxcontroller controller = Get.find<getxcontroller>();
  TextEditingController Pass1 = TextEditingController();
  TextEditingController Pass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ChangePassword"),
        ),
        body: ListView(
          children: [
            TextFormField(
              controller: Pass1,
              decoration: InputDecoration(
                  hintText: "Enter New Password : ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if (value!.length < 2) {
                  return "The Password is too small.";
                } else {
                  Pass1.text = value;
                }
              },
              onSaved: (newValue) {
                Pass1.text = newValue!;
              },
            ),
            TextFormField(
              controller: Pass2,
              decoration: InputDecoration(
                  hintText: "Confirm New Password : ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              validator: (value) {
                if (value!.length < 2) {
                  return "The Password is too small.";
                } else {
                  Pass2.text = value;
                }
              },
              onSaved: (newValue) {
                Pass2.text = newValue!;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (Pass1.text == Pass2.text) {
                    print("Yeeeeeeeeeeeeeeeeeeeeeeeeeeeeees");
                    controller.changePass(Pass1.text);
                  } else {
                    print("Nooooooooooooooooooooooooooooooooo");
                    Text("Not Equal");
                  }
                },
                child: Text("Change"))
          ],
        ));
  }
}

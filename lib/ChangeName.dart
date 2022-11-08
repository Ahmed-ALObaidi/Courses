import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';

class ChangeName extends StatelessWidget {
  getxcontroller controller = Get.find<getxcontroller>();
  TextEditingController username = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change NAME"),
        ),
        body: ListView(
          children: [
            SizedBox(height: 50,),
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Enter Your New User Name : "),
                  Flexible(
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          hintText: "New User Name : ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.length < 2) {
                          return "The User Name is too small.";
                        } else {
                          username.text = value;
                        }
                      },
                      onSaved: (newValue) {
                        username.text = newValue!;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text("Enter Your New First Name : "),
                  Flexible(child: TextFormField(
                    controller: firstname,
                    decoration: InputDecoration(
                        hintText: "New First Name : ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.length < 2) {
                        return "The First Name is too small.";
                      } else {
                        firstname.text = value;
                      }
                    },
                    onSaved: (newValue) {
                      firstname.text = newValue!;
                    },
                  ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text("Enter Your New Last Name : "),
                  Flexible(
                    child: TextFormField(
                      controller: lastname,
                      decoration: InputDecoration(
                          hintText: "New Last Name : ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.length < 2) {
                          return "The Last Name is too small.";
                        } else {
                          lastname.text = value;
                        }
                      },
                      onSaved: (newValue) {
                        lastname.text = newValue!;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.info,
                    body: const Center(
                      child: Text(
                        'Do you want to Save changes',
                        style: TextStyle(
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    title:
                    'Do you want to Save changes ? ',
                    btnOkOnPress: () async {
                      controller.ChangeAccountName(username.text , firstname.text , lastname.text);
                      Get.offNamed("/Account");
                    },
                    btnCancelOnPress: () {Navigator.pop(context);},
                  ).show();

                },
                child: Text("Save Changes"))
          ],
        ));
  }
}

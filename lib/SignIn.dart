import 'package:courses/Constants.dart';
import 'package:flutter/material.dart';
import 'package:courses/Account.dart';
import 'package:courses/Favorite.dart';
import 'package:courses/HomePage.dart';
import 'package:courses/Search.dart';
import 'package:courses/SignUP.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'GetxController.dart';
import 'Home.dart';

class SignIn extends StatelessWidget {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  signin() async {
    FormState? formdata = formstate.currentState;

    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: Constants.emailup, password: Constants.passup);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formstate,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 400,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Email : ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value!.length < 2) {
                    return "The Email is too small.";
                  } else {
                    Constants.emailup = value;
                  }
                },
                onSaved: (newValue) {
                  Constants.emailup = newValue!;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Password : ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value!.length < 2) {
                    return "The Pass is too small.";
                  } else {
                    Constants.passup = value;
                  }
                },
                onSaved: (newValue) {
                  Constants.passup = newValue!;
                },
              ),
              Row(
                children: [
                  Text("If you dont have an account "),
                  TextButton(
                      onPressed: () {
                        Get.offNamed("/SignUP");
                      },
                      child: Text("Click Here.")),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    var response = await signin();
                    if (response != null) {
                      print("hello ==================================");
                      Get.offNamed("/Home");
                    }
                  },
                  child: Text("Sign In")),
            ],
          ),
        ),
      ),
    );
  }
}

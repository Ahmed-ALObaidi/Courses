import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUP extends StatelessWidget {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  signup() async {
    FormState? formdata = formstate.currentState;
    formdata?.save();
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        password: Constants.passup!,
        email: Constants.emailup!,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "First Name : ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.length < 2) {
                        return "The First Name is too small.";
                      } else {
                        Constants.fname = value;
                      }
                    },
                    onSaved: (newValue) {
                      Constants.fname = newValue!;
                    },
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Last Name : ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.length < 2) {
                        return "The Last Name is too small.";
                      } else {
                        Constants.lname = value;
                      }
                    },
                    onSaved: (newValue) {
                      Constants.lname = newValue!;
                    },
                  )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Phone Number : ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value!.length < 2) {
                    return "The Phone Number is too small.";
                  } else {
                    Constants.phone = value;
                  }
                },
                onSaved: (newValue) {
                  Constants.phone = newValue!;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Username : ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value!.length < 2) {
                    return "The Username is too small.";
                  } else {
                    Constants.usernameup = value;
                  }
                },
                onSaved: (newValue) {
                  Constants.usernameup = newValue!;
                },
              ),
              SizedBox(
                height: 20,
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
                    return "The Password is too small.";
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
                  Text("If you have an account "),
                  TextButton(
                      onPressed: () {
                        Get.offNamed("/SignIn");
                      },
                      child: Text("Click Here.")),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("${FirebaseAuth.instance.currentUser}");
                    var response = await signup();
                    if (response != null) {
                      print("heloo ==========================================");
                      FirebaseFirestore.instance.collection("users").add({
                        "username": Constants.usernameup,
                        "firstname": Constants.fname,
                        "lname": Constants.fname,
                        "phonenumber": Constants.phone,
                        "email": Constants.emailup,
                        "pass": Constants.passup,
                        "uid": FirebaseAuth.instance.currentUser?.uid
                      });
                      print(
                          "done =====================================================");
                      Get.offNamed("/Home");
                    }
                  },
                  child: Text("Sign UP")),
            ],
          ),
        ),
      ),
    );
  }
}

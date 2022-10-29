import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';

class Favorite extends StatelessWidget {
  getxcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favorite"),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("courses")
              .where("favorite", isEqualTo: 1)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.info,
                        body: const Center(
                          child: Text(
                            'Do you want to delete this course',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        title: 'Do you want to delete this course ? ',
                        btnOkOnPress: () async {
                          await controller.deletecourse(
                              "video/course ${snapshot.data!.docs[index].get('title')}",
                              '${snapshot.data!.docs[index].id}');
                        },
                        btnCancelOnPress: () {},
                      ).show();
                    },
                    title: Text(
                      snapshot.data!.docs[index].get('title'),
                    ),
                    onTap: () {
                      Get.toNamed("/Course");
                      Constants.titleofcourse =
                          snapshot.data!.docs[index].get('title');
                    },
                    trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("courses")
                            .doc('${snapshot.data!.docs[index].id}')
                            .update({
                          "favorite": FieldValue.delete(),
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ));
                },
              );
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ));
  }
}

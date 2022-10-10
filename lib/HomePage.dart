import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'Constants.dart';
import 'GetxController.dart';
class HomePage extends StatefulWidget{

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getxcontroller controller = Get.find();
  late Future<ListResult> futuretop5;
  StreamController <List<DocumentSnapshot>> _streamController = StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];
  bool _isRequesting = false;
  bool _isFinish = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) => productChange.doc.id == product.id,
        );
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) => productChange.doc.id == product.id,
          );
          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });
    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    print("${FirebaseAuth.instance.currentUser}////////////////////////");
    FirebaseFirestore.instance
        .collection('courses').where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }


  void requestNextPage() async {
    print("${_products}*++++++++++++++++++++++++***");
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('courses').where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('title')
            .limit(5)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('courses').where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('title')
            .startAfterDocument(_products[_products.length - 1])
            .limit(5)
            .get();
      }if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar:AppBar(
    //       title: const Text("Homepage"),
    //       actions: [
    //         IconButton(onPressed: () {
    //           Get.offNamed("/AddCourses");
    //         }, icon: const Icon(Icons.add))
    //       ],
    //     ),
    //     body: ListView(
    //       children: [
    //         Container(
    //           height: 200,width: double.infinity,
    //           decoration: const BoxDecoration(color: Colors.red , borderRadius: BorderRadius.all(Radius.circular(20))),
    //           margin: const EdgeInsets.all(10),
    //           child: Container(
    //             padding: const EdgeInsets.all(10),
    //             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //               stream: FirebaseFirestore.instance.collection("courses").orderBy("Time",descending: true).snapshots(),
    //               builder: (context, snapshot) {
    //                 if (snapshot.hasData) {
    //                   return PageView.builder(
    //                     itemCount: snapshot.data!.docs.length <= 3 ? snapshot.data!.docs.length : 3,
    //                     itemBuilder: (context, index) {
    //                       return ListTile(
    //                         title: Text(
    //                           snapshot.data!.docs[index].get('title'),
    //                         ),
    //                         onTap: () {
    //                           Constants.titleofcourse = snapshot.data!.docs[index].get('title');
    //                           Get.toNamed("/Course");
    //                         },
    //                       );
    //                     },
    //                   );
    //                 }
    //                 if (snapshot.hasError) {
    //                   return const Text('Error');
    //                 } else {
    //                   return const CircularProgressIndicator();
    //                 }
    //               },
    //             ),
    //           ),
    //         ),
    //
    //
    //         //******************************************************************************************//
    //
    //
    //         // ListView.builder(
    //         //   controller: _scrollcontroller,
    //         //   shrinkWrap: true,
    //         //   physics: NeverScrollableScrollPhysics(),
    //         //   itemBuilder: (context, index) {
    //         //   if(index < controller.items.length){
    //         //     return ListTile(title: Text("${controller.items[index]}/******************/"),);
    //         //   }else{
    //         //     return ListTile(title: Text("NOOOOOOOOOOOOOO Data Here"),);
    //         //   }
    //         // },itemCount: controller.hasmoredata ? controller.items.length : controller.items.length + 1,)
    //
    //
    //         // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //         //   stream: FirebaseFirestore.instance.collection("courses").limit(2).orderBy("Time").snapshots(),
    //         //   builder: (BuildContext context,AsyncSnapshot snapshot) {
    //         //     if (snapshot.hasData) {
    //         //       return ListView.builder(
    //         //         shrinkWrap: true,
    //         //         physics: NeverScrollableScrollPhysics(),
    //         //         itemCount: snapshot.data!.docs.length,
    //         //         itemBuilder: (context, index) {
    //         //           return Container(
    //         //             width: double.infinity,
    //         //             height: 200,
    //         //             child: Card(
    //         //                 child: ListTile(
    //         //                   onLongPress: () {
    //         //                     AwesomeDialog(
    //         //                       context: context,
    //         //                       animType: AnimType.scale,
    //         //                       dialogType: DialogType.info,
    //         //                       body: const Center(child: Text(
    //         //                         'Do you want to delete this course',
    //         //                         style: TextStyle(fontStyle: FontStyle.italic),
    //         //                       ),),
    //         //                       title: 'Do you want to delete this course ? ',
    //         //                       btnOkOnPress: () async {
    //         //                         await controller.deletecourse("video/course ${snapshot.data!.docs[index].get('title')}",  '${snapshot.data!.docs[index].id}');
    //         //                       },
    //         //                       btnCancelOnPress: () {},
    //         //                     ).show();
    //         //                   },
    //         //                   title: Text(
    //         //                     snapshot.data!.docs[index].get('title'),
    //         //                   ),
    //         //                   onTap: () {
    //         //                     Get.toNamed("/Course");
    //         //                     Constants.titleofcourse = snapshot.data!.docs[index].get('title');
    //         //                   },
    //         //                   trailing: IconButton(onPressed: () {
    //         //                     if(snapshot.data!.docs[index].get('favorite') == 0){
    //         //                       FirebaseFirestore.instance.collection("courses").doc('${snapshot.data!.docs[index].id}').
    //         //                       update(
    //         //                           {
    //         //                             "favorite": 1,
    //         //                           });
    //         //                     }else{
    //         //                       FirebaseFirestore.instance.collection("courses").doc('${snapshot.data!.docs[index].id}').
    //         //                       update(
    //         //                           {
    //         //                             "favorite": 0,
    //         //                           });
    //         //                     }
    //         //                   },
    //         //                     icon:
    //         //                     //?
    //         //                     // const Icon(Icons.favorite , color: Colors.red,) :
    //         //                     const Icon(Icons.favorite_border , color: null,),
    //         //                   ),
    //         //                 )),
    //         //           );
    //         //         },
    //         //       );
    //         //     }
    //         //     if (snapshot.hasError) {
    //         //       return const Text('Error');
    //         //     } else {
    //         //       return const CircularProgressIndicator();
    //         //     }
    //         //   },
    //         // )
    //       ],)
    // );


    /**************************************************/


    return Scaffold(
           appBar:AppBar(
             title: const Text("Homepage"),
             actions: [
               IconButton(onPressed: () {
                 Get.offNamed("/AddCourses");
               }, icon: const Icon(Icons.add))
             ],
           ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
              requestNextPage();
            }
            return true;
          },

          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: _streamController.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  log("Items: " + snapshot.data!.length.toString());
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: ListTile(
                        title: new Text(snapshot.data![index]['title']),
                        subtitle: new Text(snapshot.data![index]['price']),
                        onTap: () {
                          Constants.titleofcourse = snapshot.data![index]['title'];
                        Get.toNamed("/Course");
                         },

                       trailing: IconButton(onPressed: () {
                         print("${snapshot.data![index]['favorite'] }**************************");
                      if(snapshot.data![index]['favorite'] == 0){
                        FirebaseFirestore.instance.collection("courses").doc('${snapshot.data![index].id}').
                     update(
                           {
                           "favorite": 1,
                         });
                   }else{
                         FirebaseFirestore.instance.collection("courses").doc('${snapshot.data![index].id}').
                      update(
                       {
                             "favorite": 0,
                          });
                  }
             },
                       icon:
   // ?
   //         const Icon(Icons.favorite , color: Colors.red,) :
          const Icon(Icons.favorite_border , color: null,),
           ),
            )),
                  );}}

                      ),
                    ),
                  );
              }
  }




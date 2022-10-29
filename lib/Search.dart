import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'Constants.dart';
import 'GetxController.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  getxcontroller controller = Get.find<getxcontroller>();

  final TextEditingController searchController = TextEditingController();

/*
*
*   TextEditingController _searchController = TextEditingController();
//TODO Make sure to provide your own Collection instead of 'all_Notes'
  CollectionReference allNoteCollection =
  FirebaseFirestore.instance.collection('courses');
  List<DocumentSnapshot> documents = [];

  String searchText = '';
*
* */
  // late QuerySnapshot snapshotData;
  late var snapshotData;

  @override
  Widget build(BuildContext context) {
    Widget SearchedData() {
      return GetBuilder<getxcontroller>(
          init: getxcontroller(),
          builder: (controller) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                    child: ListTile(
                  title: Text(
                    snapshotData.docs[index].get("title").toString(),
                  ),
                  onTap: () {
                    Constants.titleofcourse =
                        snapshotData.docs[index].get("title").toString();
                    Get.toNamed("/Course");
                  },
                ));
              },
              itemCount: snapshotData.docs.length,
            );
          });
    }

    /*return GetBuilder<getxcontroller>(
            init: getxcontroller(),
            builder: (controller) {
              return
              ListView.builder(itemBuilder: (context, index) {
                return InkWell(
                  child: ListTile(
                    title: Text(snapshotData.docs[index].get("title").toString()),
                  ),
                  onTap: () {
                    Constants.titleofcourse =
                        snapshotData.docs[index].get("title").toString();
                    Get.toNamed("/Course");
                  },
                );
              }, itemCount: snapshotData.docs.length,);
            }
          );*/
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Constants.isExcuted = false;
            setState(() {});
          },
          child: const Icon(Icons.clear)),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   tooltip: 'Search people',
      //   onPressed: () async => showSearch (
      //     context: context,
      //     delegate: SearchPage(
      //       items: await doclist,
      //       searchLabel: 'Search people',
      //       suggestion: Center(
      //         child: Text('Filter people by name, surname or age'),
      //       ),
      //       failure: Center(
      //         child: Text('No person found :('),
      //       ),
      //       filter:
      //           (FirebaseFirestore.instance.collection("courses").docs()) => [
      //         doclist.printInfo(),
      //       ]
      //         ,
      //       builder: (person) => ListTile(
      //         title: Text(person.name),
      //         subtitle: Text(person.surname),
      //         trailing: Text('${person.age} yo'),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        actions: [
          GetBuilder<getxcontroller>(
            builder: (cont) {
              return IconButton(
                  onPressed: () {
                    cont.newquerydata(searchController.text).then((value) {
                      snapshotData = value;
                      controller.setBoolValue(true);
                      print(
                          "Done==========================${Constants.isExcuted}");
                      setState(() {});
                    });
                  },
                  icon: Icon(Icons.search));
            },
            init: getxcontroller(),
          )
        ],
        title: GetBuilder<getxcontroller>(
          init: getxcontroller(),
          builder: (controller) {
            return TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Search Courses",
                  hintStyle: TextStyle(color: Colors.white)),
              controller: searchController,
            );
          },
        ),
        backgroundColor: Colors.red,
        /*
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
                getxcontroller.name = val;
                print("${getxcontroller.name}+++++++++++++++++++++++++++++++");
            },
          ),
        ),
         */
      ),
      body: Constants.isExcuted != false
          ?
          // GetBuilder<getxcontroller>(builder: (controller) {
          //   return
          SearchedData()
          // },)
          : Container(
              child: Center(
                child: Text("Search any course ${Constants.isExcuted}"),
              ),
            ),
/*
      StreamBuilder<QuerySnapshot>(
          stream:
          // (getxcontroller.name != null && getxcontroller.name != "")
          //     ? controller.searchData(getxcontroller.name)
          //     : controller.stream(),
          // controller.streamlist(),

          // (getxcontroller.name != null && getxcontroller.name != "") ?
          // FirebaseFirestore.instance.collection("courses")
          //     .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          //     .where("title",isEqualTo: getxcontroller.name).snapshots()


          // FirebaseFirestore.instance.collection("courses")
          //     .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          //     .where("title", isGreaterThanOrEqualTo: getxcontroller.name , isLessThan: getxcontroller.name + 'z').snapshots()
          //     :
          // FirebaseFirestore.instance.collection("courses")
          //     .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          FirebaseFirestore.instance.collection("courses")
              .where("userid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where("arrayname" , arrayContains:getxcontroller.name )
              .snapshots(),

          // controller.streambuild(),

          builder: (BuildContext context,AsyncSnapshot snapshot) {
            print("${getxcontroller.name}---------------------------------------");
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                return Card(
                  child: Row(
                    children: <Widget>[
                      Text(
                        data['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

 */
    );
  }
}

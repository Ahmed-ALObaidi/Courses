import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:search_page/search_page.dart';
import 'Constants.dart';
import 'GetxController.dart';
class Search extends StatelessWidget{
  getxcontroller controller = Get.find();
  var doclist = FirebaseFirestore.instance.collection("courses").snapshots().toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        appBar:AppBar(
          title: Text("Search"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
          //
          // (name != "" && name != null)
          //     ? FirebaseFirestore.instance
          //     .collection('items')
          //     .where("searchKeywords", arrayContains: name)
          //     .snapshots()
          //     :
          FirebaseFirestore.instance.collection("courses").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                return Card(
                  child: Row(
                    children: <Widget>[
                      Text(
                        data['title'],
                        style: TextStyle(
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
    );
  }
  //   );
  // }

}
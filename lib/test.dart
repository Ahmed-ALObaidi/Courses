// import 'package:flutter/material.dart';
// import 'dart:async';
//
// final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: MotivatorChat(),
//         ),
//       ),
//     );
//   }
// }
//
// class MotivatorChat extends StatefulWidget {
//   @override
//   _MotivatorChatState createState() => _MotivatorChatState();
// }
//
// class _MotivatorChatState extends State<MotivatorChat> {
//   Firestore firestore = Firestore.instance;
//   List<DocumentSnapshot> chats = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   int documentLimit = 20;
//   late DocumentSnapshot lastDocument;
//   ScrollController _scrollController = ScrollController();
//
//   StreamController<List<DocumentSnapshot>> _controller =
//   StreamController<List<DocumentSnapshot>>();
//
//   Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;
//
//   @override
//   void initState() {
//     super.initState();
//     getChats();
//     _scrollController.addListener(() {
//       double maxScroll = _scrollController.position.maxScrollExtent;
//       double currentScroll = _scrollController.position.pixels;
//       double delta = MediaQuery.of(context).size.height * 0.20;
//       if (maxScroll - currentScroll <= delta) {
//         getChats();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }
//
//   getChats() async {
// //     if (!hasMore) {
// //       print('No More Chats');
// //       return;
// //     }
//     if (isLoading) {
//       return;
//     }
//     setState(() {
//       isLoading = true;
//     });
//     QuerySnapshot querySnapshot;
//     if (lastDocument == null) {
// //       querySnapshot = await firestore
// //           .collection('chats')
// //           .orderBy('timestamp', descending: true)
// //           .limit(documentLimit)
// //           .getDocuments();
//       querySnapshot = await firestore.getDocuments(documentLimit);
//     } else {
// //       querySnapshot = await firestore
// //           .collection('chats')
// //           .orderBy('timestamp', descending: true)
// //           .startAfterDocument(lastDocument)
// //           .limit(documentLimit)
// //           .getDocuments();
// //       print(1);
//
//       querySnapshot = await firestore.getDocuments(documentLimit, lastDocument);
//     }
// //     if (querySnapshot.documents.length < documentLimit) {
// //       hasMore = false;
// //     }
//
//     if (querySnapshot.documents.isEmpty) {
//       print('No More Chats');
//       setLoading(false);
//       return;
//     }
//
//     lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
//
//     chats.addAll(querySnapshot.documents);
//     _controller.sink.add(chats);
//
//     setLoading(false);
//   }
//
//   void setLoading([bool value = false]) => setState(() {
//     isLoading = value;
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Pagination with Firestore'),
//       ),
//       body: Column(children: [
//         Expanded(
//           child: StreamBuilder<List<DocumentSnapshot>>(
//             stream: _streamController,
//             builder: (sContext, snapshot) {
//               print(snapshot.connectionState);
//               if (snapshot.hasData && snapshot.data?.length > 0) {
//                 return
//
//                   ListView.builder(
//                     reverse: true,
//                     controller: _scrollController,
//                     itemCount: snapshot.data?.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(top: 20),
//                         child: Container(
//                           height: 20,
//                           child: Text(snapshot.data![index].data['text']!),
//                         ),
//                       );
//                     },
//                   )
//                 ;
//               } else {
//                 return Center(
//                   child: Text('No Data...'),
//                 );
//               }
//             },
//           ),
//         ),
//         isLoading
//             ? Container(
//           width: MediaQuery.of(context).size.width,
//           padding: EdgeInsets.all(5),
//           color: Colors.yellowAccent,
//           child: Text(
//             'Loading',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         )
//             : Container(),
//       ]),
//     );
//   }
// }
//
// class DocumentSnapshot {
//   DocumentSnapshot(int n) {
//     data = {"text": "$n"};
//   }
//
//   Map<String, String> data;
// }
//
// class QuerySnapshot {
//   QuerySnapshot(this.documents);
//
//   final List<DocumentSnapshot> documents;
// }
//
// class Firestore {
//   static Firestore instance = Firestore();
//   static List<DocumentSnapshot> chats;
//
//   Firestore(){
//     chats = List.generate(51, (i) => DocumentSnapshot(i));
//     increment();
//   }
//
//   Future<void> increment() async{
//
//     while(true){
//
//       var counter = chats.length;
//       await Future.delayed(Duration(seconds:3));
//
//       chats.addAll(List.generate(10, (i) => DocumentSnapshot(i + counter)));
//     }
//   }
//
//
//
//   Future<QuerySnapshot> getDocuments([required int limit, DocumentSnapshot last]) async {
//     if (last == null) {
//       return QuerySnapshot(chats.take(limit).toList());
//     }
//
//     final skip = chats.indexWhere((p) => p == last) + 1;
//     return QuerySnapshot(chats.skip(skip).take(limit).toList());
//   }
// }
import 'package:courses/Account.dart';
import 'package:courses/Constants.dart';
import 'package:courses/Favorite.dart';
import 'package:courses/HomePage.dart';
import 'package:courses/Search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'GetxController.dart';

class Home extends StatelessWidget{
  getxcontroller controller = Get.find();
  List<Widget> pages = [
    HomePage(),
    Search(),
    Favorite(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<getxcontroller>(
            init: getxcontroller(),
            builder: (_) => pages[Constants.currentIndex]),
        bottomNavigationBar:
        GetBuilder<getxcontroller>(
            init: getxcontroller(),
            builder: (_) =>
                BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: Constants.currentIndex,
                  onTap: (value) {
                    controller.BottomNavigationBaronTap(value);
                    print("${Constants.currentIndex}");
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home) ,label: "Home" ),
                    BottomNavigationBarItem(icon: Icon(Icons.search) ,label: "Search",),
                    BottomNavigationBarItem(icon: Icon(Icons.favorite) ,label: "Favorite" ),
                    BottomNavigationBarItem(icon: Icon(Icons.account_box) ,label: "Account" ),
                  ],))
    );
  }
}
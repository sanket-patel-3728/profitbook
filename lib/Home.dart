import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:profitbook/Add.dart';
import 'package:profitbook/oldTransactionList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 30),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          Add(),
          OldTransactionList(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.red,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text(
                "Add New",
                style: TextStyle(fontSize: 15.0),
              )),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text(
              "Old Transaction",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}

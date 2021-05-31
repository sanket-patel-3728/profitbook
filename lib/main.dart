import 'package:flutter/material.dart';
import 'package:profitbook/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buddies',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

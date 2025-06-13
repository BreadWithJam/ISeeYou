import 'package:flutter/material.dart';
import 'package:iseeyou_2/Tabs/SignUp.dart';


class MainPage extends StatefulWidget {

  const MainPage ({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return SignUp();
  }
}
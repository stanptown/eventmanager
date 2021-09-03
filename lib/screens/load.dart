import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/adminhome.dart';
import 'package:events_manager_app/screens/home.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:events_manager_app/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = '/loading';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

var allEvents;

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    loader();
  }

  void loader() async{
      await loadToDo();
      await loadEvents();
      await getProfileImage();
      isAdmin ? Navigator.pushNamed(context, AdminHomeScreen.id) : Navigator.pushNamed(context, HomeScreen.id);

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SpinKitFoldingCube(
        color: Colors.white,

      ),
    );
  }
}

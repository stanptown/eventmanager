import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/adminhome.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:flutter/material.dart';
import 'package:events_manager_app/screens/home.dart';

var allToDo;
List<dynamic> myToDo = [];
List<Event> myToDoEvents = [];

Future<void> loadToDo() async{
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot = await _collectionReference.get();

  allToDo = querySnapshot.docs.map((doc) => doc.data()).toList();
  print(allToDo);
  for(var user in allToDo){
    if(user['email'] == email){
      myToDo = user['todo'];
      userName2 = user['name'];
      userName = user['name'];

    }
  }
  print(myToDo);
}
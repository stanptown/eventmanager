import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/load.dart';
import 'package:events_manager_app/utils/alert.dart';
import 'package:events_manager_app/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ToDoScreen extends StatefulWidget {
  static const String id = '/todo';

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {

  @override
  void initState() {
    super.initState();
    print(myToDoEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Your toDo Screen"
        ) ,
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: (){
            Phoenix.rebirth(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: myToDoEvents.length != 0 ? ListView.builder(
          itemCount: myToDoEvents.length,
          itemBuilder: (context, index){
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12.0),
              ),
              // width: MediaQuery.of(context).size.width*0.7,
              child: ListTile(
                title: Text(
                  myToDoEvents[index].title,
                ),
                subtitle: Text(
                  myToDoEvents[index].uid.substring(0, 10),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_sweep_sharp,
                  ),
                  onPressed: (){
                    setState(() {
                      myToDo.remove(myToDoEvents[index].uid);
                      FirebaseFirestore.instance.collection('users')
                        .doc(email)
                        .update({
                          'todo' : myToDo,
                        })
                        .then((value) {
                          myToDoEvents.removeAt(index);
                          Navigator.pushNamed(context, LoadingScreen.id);
                        })
                        .catchError((err){
                          showAlert(context, err);
                        });
                    });
                  },
                ),
              ),
            );
          },
        ) : Center(
          child: Text(
            'No events available in your To-Do. :/',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

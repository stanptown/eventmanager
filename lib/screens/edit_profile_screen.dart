import 'dart:io';
import 'package:events_manager_app/screens/admin_home_screen.dart';

import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:events_manager_app/utils/alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'admin_home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = '/profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  String editProfileName =userName2;
  // String editProfileName2 = userName;
  File imageFile = File(profileImagePath);
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Profile Name",
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: (){
            Navigator.pushNamed(context, LoadingScreen.id);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Edit your Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
                ),
              ),

              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (val){
                  editProfileName=val;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your correct profile name: ',

                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(
                        // color: Colors.redAccent,
                        width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(
                        // color: Colors.redAccent,
                        width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.download_done_outlined,
        ),
        backgroundColor: Colors.orange,
        onPressed: () async{
          FirebaseFirestore.instance.collection('users')
              .doc(email)
              .update({
                'name' : editProfileName,
              })
              .then((value) async{
                try{
                  await FirebaseStorage.instance
                      .ref('$email/profile.png')
                      ;
                  ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Edit successful'));
                  Navigator.pushNamed(context, LoadingScreen.id);
                } on FirebaseException catch (err){
                  showAlert(context, err.toString());
                }
              })
              .catchError((err){
                showAlert(context, err);
              });
        },
      ),
    );
  }
}

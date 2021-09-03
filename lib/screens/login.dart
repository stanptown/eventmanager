import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/load.dart';
import 'package:events_manager_app/utils/alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmail = '';
  String loginPassword = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(15.0),


            child: Column(
              children: [

              Container(
              height: 300,
              child: Image(image: AssetImage("images/main2.jpeg"),
                fit: BoxFit.contain
                ,
              ),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val){
                    loginEmail=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your email id: ',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  obscureText: true,
                  onChanged: (val){
                    loginPassword=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password: ',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  onPressed: () async{
                    try {
                      UserCredential userCredential = await auth.signInWithEmailAndPassword(
                          email: loginEmail,
                          password: loginPassword,
                      );
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('email', loginEmail);
                      email = loginEmail;
                      validateAdmin(email);
                      Navigator.pushNamed(context, LoadingScreen.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showAlert(context, 'No such user found');
                      } else if (e.code == 'wrong-password') {
                        showAlert(context, 'Invalid Password');
                      }
                    }
                  },
                  child: Text(
                      'Login'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

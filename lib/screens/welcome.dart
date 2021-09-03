import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:events_manager_app/screens/signup.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: Image(image: AssetImage("images/main1.jpeg"),
                  fit: BoxFit.contain,),
              ),
              SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                    text: 'Welcome to ',style: TextStyle(fontSize: 25.0,fontWeight : FontWeight.bold,
                    color: Colors.black
                ),

                    children: <TextSpan>[
                      TextSpan(
                          text: 'Event Manager',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold
                          ,color: Colors.orange)
                      ),

                    ]
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, LoginPage.id);
                },
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                child: Text(
                  'Log In',
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, SignUpPage.id);
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text(
                  'Sign Up',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

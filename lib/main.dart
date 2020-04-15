import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_hunter/Models/appConstants.dart';
import 'package:hotel_hunter/Screens/myPostingsPage.dart';
import 'package:hotel_hunter/Screens/viewPostingPage.dart';
import 'package:hotel_hunter/Views/listWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/bookPostingPage.dart';
import 'Screens/conversationPage.dart';
import 'Screens/createPostingPage.dart';
import 'Screens/guestHomePage.dart';
import 'Screens/hostHomePage.dart';
import 'Screens/loginPage.dart';
import 'Screens/personalInfoPage.dart';
import 'Screens/signUpPage.dart';
import 'Screens/viewProfilePage.dart';
import 'Screens/forgotpassword.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        GuestHomePage.routeName: (context) => GuestHomePage(),
        PersonalInfoPage.routeName: (context) => PersonalInfoPage(),
        ViewProfilePage.routeName: (context) => ViewProfilePage(),
        BookPostingPage.routeName: (context) => BookPostingPage(),
        ConversationPage.routeName: (context) => ConversationPage(),
        HostHomePage.routeName: (context) => HostHomePage(),
        CreatePostingPage.routeName: (context) => CreatePostingPage(),
        Forgotpassword.routeName: (context) => Forgotpassword(),
        MyPostingListTile.routeName: (context) => MyPostingListTile(),
        MyPostingsPage.routeName: (context) => MyPostingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  getLogin() async {
    await Future.delayed(Duration.zero);
    SharedPreferences.getInstance().then((pref) {
      if (pref.containsKey("Login")) {
        if (pref.getBool("Login") == true) {
          Firestore.instance
              .collection("users")
              .document(pref.getString("UserId"))
              .updateData({
            "Status": 1,
          });
          Firestore.instance
              .collection("users")
              .document(pref.getString("UserId"))
              .get()
              .then((data) {
            AppConstants.currentUser.firstName = data.data["firstName"];
            AppConstants.currentUser.lastName = data.data["lastName"];
            AppConstants.currentUser.city = data.data["city"];
            AppConstants.currentUser.country = data.data["country"];
            AppConstants.currentUser.state = data.data["state"];
            AppConstants.currentUser.bio = data.data["bio"];

            AppConstants.currentUser.id = pref.getString("UserId");
            AppConstants.currentUser.email = data.data["Email"];
            Navigator.pushNamed(context, GuestHomePage.routeName);

          });
          //Navigator.pushNamedAndRemoveUntil(context, "/Home", (Route<dynamic> route) => false);
        }
      } else {
        Navigator.pushNamed(context, LoginPage.routeName);

      }
    });
  }

  @override
  void initState() {

    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(context, LoginPage.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.hotel,
              size: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                '${AppConstants.appName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

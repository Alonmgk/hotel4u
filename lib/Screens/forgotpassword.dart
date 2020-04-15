import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_hunter/Models/appConstants.dart';
import 'package:hotel_hunter/Models/data.dart';
import 'package:hotel_hunter/Models/userObjects.dart';
import 'guestHomePage.dart';
import 'loginPage.dart';
import 'signUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_hunter/Loading.dart';

enum AuthFormType { signIn, signUp, reset }

class Forgotpassword extends StatefulWidget {

  static final String routeName = '/passwordresetPageRoute';


  final AuthFormType authFormType;
  Forgotpassword({Key key,@required this.authFormType}) : super(key: key);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {



  Future sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((forgot){
      Fluttertoast.showToast(msg: "Link Sent to Email-Id",);
      //Navigator.pushNamed(context, LoginPage.routeName);
    }).
    catchError((e){
      Fluttertoast.showToast(msg: "Email-id Not Exist",);

      print(e.details);
    });
  }


  TextEditingController _emailController = TextEditingController();
  AuthFormType authFormType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email'
                    ),
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    validator: (text) {
                      if (!text.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    controller: _emailController,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: MaterialButton(
                    onPressed: () {
                      if(_emailController.text==null || _emailController.text==""){
                        Fluttertoast.showToast(msg: "Email-Id Can't be Blank",);

                      }
                      else {
                        //Fluttertoast.showToast(msg: "Successful",);

                        sendPasswordResetEmail(_emailController.text
                            .toString());
                      }
                      },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                    color: Colors.grey,
                    height: MediaQuery.of(context).size.height / 12,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

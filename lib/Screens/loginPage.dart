import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_hunter/Models/appConstants.dart';
import 'package:hotel_hunter/Models/data.dart';
import 'package:hotel_hunter/Models/userObjects.dart';
import 'guestHomePage.dart';
import 'signUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'forgotpassword.dart';
import 'package:hotel_hunter/Loading.dart';


enum AuthFormType { signIn, signUp, reset }

class LoginPage extends StatefulWidget {

  final AuthFormType authFormType;


  static final String routeName = '/loginPageRoute';

  LoginPage({Key key,@required this.authFormType}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {




  AuthFormType authFormType;


  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signUp() {
    if (_formKey.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      AppConstants.currentUser = User();
      AppConstants.currentUser.email = email;
      AppConstants.currentUser.password = password;
      Navigator.pushNamed(context, SignUpPage.routeName);
    }
  }

  void _login()async{
    if (_formKey.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((firebaseUser) {
        Dialogs.showLoadingDialog(context);

        String userID = firebaseUser.user.uid;
        AppConstants.currentUser = User(id: userID);
         AppConstants.currentUser.getPersonalInfoFromFirestore().whenComplete(() {
          //Dialogs.showLoadingDialog(context);
          Navigator.pushNamed(context, GuestHomePage.routeName);
        });

      }).catchError((e){
        Fluttertoast.showToast(msg: "Email-id Not Exist Or Incorrect Password",);

        print(e.details);
      });
    }

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to ${AppConstants.appName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
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
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Password'
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          obscureText: true,
                          validator: (text) {
                            if (text.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: MaterialButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height / 12,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: MaterialButton(
                    onPressed: () {
                      _signUp();
                    },
                    child: Text(
                      'Sign Up',
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

                GestureDetector(onTap:(){
                  Navigator.pushNamed(context, Forgotpassword.routeName);

                },child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(child: Text("Forgot Password",style: TextStyle(
                    fontSize: 16
                  ),)),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

}

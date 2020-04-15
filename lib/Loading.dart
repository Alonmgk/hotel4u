import 'package:flutter/material.dart';

class Dialogs {
  static showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.black,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: new Row(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(width: 20.0,),
                        Text("Please Wait....",style: TextStyle(color: Colors.white, fontSize: 25),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

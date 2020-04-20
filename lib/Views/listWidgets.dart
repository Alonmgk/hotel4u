import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_hunter/Models/appConstants.dart';
import 'package:hotel_hunter/Models/messagingObjects.dart';
import 'package:hotel_hunter/Models/postingObjects.dart';
import 'package:hotel_hunter/Models/reviewObjects.dart';
import 'package:hotel_hunter/Screens/guestHomePage.dart';
import 'package:hotel_hunter/Screens/hostHomePage.dart';
import 'package:hotel_hunter/Screens/myPostingsPage.dart';
import 'package:hotel_hunter/Screens/viewProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewListTile extends StatefulWidget {

  final Review review;

  ReviewListTile({this.review, Key key}): super(key: key);

  @override
  _ReviewListTileState createState() => _ReviewListTileState();

}

class _ReviewListTileState extends State<ReviewListTile> {

  Review _review;

  @override
  void initState() {
    this._review = widget.review;
    this._review.contact.getImageFromStorage().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        
        Row(
          children: <Widget>[
            InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(contact: _review.contact,),
                  ),
                );
              },
              child: Container(
                child: (_review.contact.displayImage == null) ? Container(
                  width: MediaQuery.of(context).size.width / 7.5,
                ) : CircleAvatar(
                  backgroundImage: _review.contact.displayImage,
                  radius: MediaQuery.of(context).size.width / 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: AutoSizeText(
                _review.contact.firstName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            StarRating(
              size: 25.0,
              starCount: 5,
              color: AppConstants.selectedIconColor,
              borderColor: Colors.grey,
              onRatingChanged: null,
              rating: _review.rating,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              AutoSizeText(
                _review.dateTime.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: <Widget>[
            AutoSizeText(
              _review.text,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class ConversationListTile extends StatefulWidget {

  final Conversation conversation;

  ConversationListTile({this.conversation, Key key}): super(key: key);

  @override
  _ConversationListTileState createState() => _ConversationListTileState();

}

class _ConversationListTileState extends State<ConversationListTile> {

  Conversation _conversation;

  @override
  void initState() {
    this._conversation = widget.conversation;
    this._conversation.otherContact.getImageFromStorage().whenComplete(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewProfilePage(contact: _conversation.otherContact),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: _conversation.otherContact.displayImage,
          radius: MediaQuery.of(context).size.width / 14.0,
        ),
      ),
      title: Text(
        _conversation.otherContact.getFullName(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.5,
        ),
      ),
      subtitle: AutoSizeText(
        _conversation.lastMessage.text,
        minFontSize: 20,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _conversation.lastMessage.getMessageDateTime(),
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
    );
  }

}

class MessageListTile extends StatelessWidget {

  final Message message;

  MessageListTile({this.message, Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.sender.firstName == AppConstants.currentUser.firstName) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          message.text,
                          textWidthBasis: TextWidthBasis.parent,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          message.dateTime.toString(),
                          //message.getMessageDateTime(),
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(contact: AppConstants.currentUser.createContactFromUser()),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: message.sender.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(contact: message.sender),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: message.sender.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          message.text,
                          textWidthBasis: TextWidthBasis.parent,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          message.dateTime.toString(),

                          //message.getMessageDateTime(),
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

}

class MyPostingListTile extends StatefulWidget {

  final Posting posting;
  static final String routeName = '/mypostinglisttile';

  MyPostingListTile({this.posting, Key key}): super(key: key);

  @override
  _MyPostingListTileState createState() => _MyPostingListTileState();

}

class _MyPostingListTileState extends State<MyPostingListTile> {

  Posting _posting;
  int index;

  void showDialog1(BuildContext context,String id) {
    // flutter defined function
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete"),
          content: new Text("Are you sure want to delete the selected Posting?"),
          actions: <Widget>[

            FlatButton(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20
                    ),
                    child:  GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },child: new Text("Cancel")),
                  ),

                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Row(
                children: <Widget>[

                  new Text("Ok"),
                ],
              ),
              onPressed: () async{
                await  Delete();
                print(AppConstants.currentUser.id);
                Fluttertoast.showToast(msg: "Delete Successfully",);


                // await AppConstants.currentUser.getPersonalInfoFromFirestore();
                /*AppConstants.currentUser.getMyPostingsFromFirestore()
                            .whenComplete(() {

                          Navigator.pushNamed(context, HostHomePage.routeName);
                        });*/
                //print(AppConstants.currentUser.getMyPostingsFromFirestore());
                //Navigator.pushNamed(context, MyPostingsPage.routeName);

                Navigator.pushReplacementNamed(context, HostHomePage.routeName);
                //AppConstants.currentUser.myPostings.removeAt(index).id.toString();

              },
            ),
            // usually buttons at the bottom of the dialog

          ],
        );
      },
    );
  }

  Delete()async{

    await Firestore.instance.collection('postings').document(_posting.id).delete();

    DocumentReference dr = Firestore.instance.document('users/${AppConstants.currentUser.id}');

    Firestore.instance.runTransaction((Transaction ts)async{

      DocumentSnapshot postSnapshot=await ts.get(dr);


      if (postSnapshot.exists) {

        if(postSnapshot.data['myPostingIDs'].contains(_posting.id))

        await ts.update(dr, <String, dynamic>{
          'myPostingIDs': FieldValue.arrayRemove([_posting.id])});
      }

    });

     //AppConstants.currentUser.myPostings.clear();

    for(int i=0;i<AppConstants.currentUser.myPostings.length;i++){

      if(AppConstants.currentUser.myPostings[i].id==_posting.id){
        AppConstants.currentUser.myPostings.removeAt(i);
      }

    }
setState(() {

});



      Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context,MyPostingsPage.routeName);

      //Navigator.of(context).pop();

     // Navigator.pushReplacementNamed(context,MyPostingsPage.routeName);



 // await AppConstants.currentUser.myPostings[0].getPostingInfoFromFirestore();

  /*  DocumentSnapshot ds = await Firestore.instance.document('users/${AppConstants.currentUser.id}').get();

    List<String> myPostingIDs = List<String>.from(ds.data['myPostingIDs']) ?? [];

    print("Ids : ${ds.data['myPostingIDs']}");
    print("Ids : $myPostingIDs");

    for (int i =0;i<myPostingIDs.length;i++) {
    //  DocumentSnapshot snapshot = await Firestore.instance.collection('postings').document(myPostingIDs[i]).get();
      Posting newPosting = await Posting(id: myPostingIDs[i]);
      await newPosting.getPostingInfoFromFirestore();
      await newPosting.getAllBookingsFromFirestore();
      await newPosting.getAllImagesFromStorage();
      AppConstants.currentUser.myPostings.add(newPosting);
    }*/
/*
 Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, HostHomePage.routeName);

    setState(() {

    });*/

  }


  @override
  void initState() {
    this._posting = widget.posting;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.all(15.0),
            leading: CircleAvatar(backgroundImage: _posting.displayImages.first==null?Text(""):_posting.displayImages.first,
            radius: 30,),

            title: Text(_posting.address,  style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,color: Colors.black
            ),),
            subtitle:   Padding(
              padding: const EdgeInsets.only(top: 5),
              child: AutoSizeText(
                _posting.name,
                maxLines: 2,
                minFontSize: 16.0,
                style: TextStyle(
                  fontWeight: FontWeight.w500,color: Colors.black
                ),
              ),
            ),

          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton(
                child: Icon(Icons.more_vert),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,size: 14,
                            ),
                          ),
                          new Text('Remove',style: TextStyle(fontSize: 15),),
                        ],
                      ),  value: 'delete'),
                ],
                onSelected: ( value){

                  if(value=="delete")
                  {
                    showDialog1(context,_posting.id);

                  }
                },
              ),
            ],
          ),
        ),

      ],
    );
  }

}

class CreatePostingListTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(Icons.add),
          ),
          Text(
            'Create a posting',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

}


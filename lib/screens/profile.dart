import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/helper/authentication.dart';
import 'package:flutter_complete_guide/models/article_card.dart';
import 'package:flutter_complete_guide/models/showFollowers.dart';
import 'package:flutter_complete_guide/models/showFollowing.dart';

class Profile extends StatefulWidget {
  final String uid;

  Profile(this.uid);
  @override
  _ProfileState createState() => _ProfileState(uid);
}

class _ProfileState extends State<Profile> {
  final String _uid;
  _ProfileState(this._uid);
  final obj = Authentication();
  String name = '';
  String url = '';
  bool _isCurrent = false;
  bool doesFollow = false;
  var showFollowers, showFollowing;

  var _len = 0;
  List<DocumentSnapshot> _arti;
  bool isloading = true;

  DocumentSnapshot following;

  Future<DocumentSnapshot> getFollowingCurrent() async {
    FirebaseUser us = await FirebaseAuth.instance.currentUser();
    following =
        await Firestore.instance.collection("follow").document(us.uid).get();
    return following;
  }

  Future<void> addFollower() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("follow")
        .document(_user.uid)
        .setData({_uid: _uid}, merge: true).whenComplete(() {
      getFollowingCurrent().then((value) {
        setState(() {
          doesFollow = false;
        });
      });
    });
  }

  Future<void> unfollowdialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm?'),
            content: Text('Are you sure to unfollow?'),
            actions: <Widget>[
              TextButton(
                child: Text('Unfollow'),
                onPressed: () {
                  removeFollower();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> removeFollower() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("follow")
        .document(_user.uid)
        .updateData({_uid: FieldValue.delete()}).whenComplete(() {
      getFollowingCurrent().then((value) {
        setState(() {
          doesFollow = false;
        });
      });
    });
  }

  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      QuerySnapshot art = await Firestore.instance
          .collection("articles")
          .where('user', isEqualTo: _uid)
          .getDocuments();
      _arti = art.documents;

      if (_len != _arti.length) {
        _len = _arti.length;
        setState(() {});
      }
    } catch (e) {
      print("sorry couldn't fetch data");
      print(e);
    }
    return _arti;
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance
            .collection('users')
            .document(_uid)
            .get()
            .then((docu) {
          _isCurrent = _uid == user.uid ? true : false;
          url = docu['image_url'];
          name = docu['fullname'];
          setState(() {
            isloading = false;
          });
        });
      });
    }
    FirebaseAuth.instance.currentUser().then((value) => print(value.uid));
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FittedBox(
                  //make this into a fitted box later
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(url),
                        backgroundColor: Colors.black,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      if (_isCurrent == false)
                        FutureBuilder(
                            future: getFollowingCurrent(),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                if (following.data != null)
                                  for (var i in following.data.keys) {
                                    if (i == _uid) doesFollow = true;
                                  }
                              }
                              return snap.hasData
                                  ? doesFollow
                                      ? FlatButton(
                                          onPressed: () {
                                            unfollowdialog();
                                          },
                                          child: Text("Unfollow"))
                                      : FlatButton(
                                          onPressed: () {
                                            addFollower();
                                          },
                                          child: Text("Follow"))
                                  : CircularProgressIndicator();
                            }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          showFollowers = new ShowFollowers(_uid);
                          showFollowers.getFollowers(context);
                        },
                        child: Text("Followers"),
                      ),
                      RaisedButton(
                        child: Text("Following"),
                        onPressed: () {
                          showFollowing = new ShowFollowing(_uid);
                          showFollowing.getFollowing(context);
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  height: 20,
                ),
                Expanded(
                  child: Center(
                    child: FutureBuilder(
                        future: getArticles(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return RefreshIndicator(
                              onRefresh: getArticles,
                              child: _arti.length == 0
                                  ? Center(child: Text("No Articles to Show "))
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return ArticleCard(_arti[index],
                                            _isCurrent, url, false);
                                      },
                                      itemCount: _arti.length,
                                    ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ],
            ),
          );
  }
}

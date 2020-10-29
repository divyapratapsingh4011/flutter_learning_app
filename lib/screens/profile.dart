import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/models/article_card.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String url = '';
  var _len = 0;
  List<DocumentSnapshot> _arti;
  bool isloading = true;
  Future<List<DocumentSnapshot>> getArticles() async {
    try {
      final FirebaseUser _user = await FirebaseAuth.instance.currentUser();

      QuerySnapshot art = await Firestore.instance
          .collection("articles")
          .where('user', isEqualTo: _user.uid)
          .getDocuments();
      _arti = art.documents;

      if (_len < _arti.length) {
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
            .document(user.uid)
            .get()
            .then((docu) {
          url = docu['image_url'];
          name = docu['fullname'];
          setState(() {
            isloading = false;
          });
        });
      });
    }
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(url),
                      backgroundColor: Colors.black,
                    ),
                    Text(name),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: null,
                      child: Text(" Followers "),
                    ),
                    RaisedButton(
                      onPressed: null,
                      child: Text(" Following "),
                    )
                  ],
                ),
                Expanded(
                  child: Center(
                    child: FutureBuilder(
                        future: getArticles(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return RefreshIndicator(
                              onRefresh: getArticles,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return ArticleCard(_arti[index], true, url);
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

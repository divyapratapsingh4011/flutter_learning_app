import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_complete_guide/screens/profile.dart';
import 'package:flutter_complete_guide/screens/zefyr_editor.dart';
=======
import 'package:flutter_complete_guide/models/user.dart';
import 'package:flutter_complete_guide/screens/profile.dart';
import 'package:flutter_complete_guide/screens/searchUsers.dart';
>>>>>>> 5aff5ea494a407c9f9fa95542d1b9f811a29ed3c
import '../screens/showArticle.dart';

class ArticleCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final bool isAuthor;
  final url;
  final bool canTap; //true if the user profile should show on tap else false

  ArticleCard(this.doc, this.isAuthor, this.url, this.canTap);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewerPage(this.widget.doc))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.doc.data["title"],
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
<<<<<<< HEAD
                  ),
                ],
              ),
              trailing: this.widget.isAuthor
                  ? IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditorPage.edit(widget.doc),
                      )),
                      color: Colors.grey,
                    )
                  : IconButton(
                      iconSize: 20,
                      icon: _isPressed
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                      onPressed: () {
                        print("bookmarked");
                        setState(() {
                          _isPressed = !_isPressed;
                        });
                      },
                      color: Colors.grey,
=======
                    Text(
                      "${this.widget.doc.data["date"]}  ${this.widget.doc.data['tag']} ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
>>>>>>> 5aff5ea494a407c9f9fa95542d1b9f811a29ed3c
                    ),
                  ],
                ),
                trailing: this.widget.isAuthor
                    ? IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.edit),
                        onPressed: () => print("edit"),
                        color: Colors.grey,
                      )
                    : IconButton(
                        iconSize: 20,
                        icon: _isPressed
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        onPressed: () {
                          print("bookmarked");
                          setState(() {
                            _isPressed = !_isPressed;
                          });
                        },
                        color: Colors.grey,
                      ),
              ),
<<<<<<< HEAD
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(widget.doc.data['username']),
                  ),
                  body: Profile(
                    widget.doc.data['user'],
                  ),
=======
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  this.widget.doc.data["caption"],
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
            ]),
          ),
          Divider(
            thickness: 2,
            indent: 15,
            endIndent: 15,
          ),
          GestureDetector(
            onTap: this.widget.canTap
                ? () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserCard(this.widget.doc.data["user"])))
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(this.widget.url),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${this.widget.doc.data["username"]}",
                  style: TextStyle(fontSize: 12),
>>>>>>> 5aff5ea494a407c9f9fa95542d1b9f811a29ed3c
                ),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(this.widget.url),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${this.widget.doc.data["username"]}",
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

final CommentsRefrence = Firestore.instance.collection("posts");

class CommentsPage extends StatefulWidget{
  final String postId;
  final String uid;
  final String postImageUrl;
  final Timestamp timestamp;
  final String displayName;
  final String photoUrl;
  final String displayNamecurrentUser;
  final int comments;


  CommentsPage({this.comments,this.postId,this.uid,this.postImageUrl,this.timestamp,this.displayName,this.photoUrl,this.displayNamecurrentUser});

  @override
  CommentsPageState createState() => CommentsPageState(comments: comments,postId: postId, uid: uid, postImageUrl: postImageUrl,timestamp: timestamp,displayName: displayName,photoUrl: photoUrl,displayNamecurrentUser: displayNamecurrentUser);
}

class CommentsPageState extends State<CommentsPage> {
  final int comments;
  final String postId;
  final String uid;
  final String postImageUrl;
  final Timestamp timestamp;
  final String displayName;
  final String photoUrl;
  final String displayNamecurrentUser;
  final GlobalKey<FormState> _CommentKey = GlobalKey<FormState>();

  String CommentId = Uuid().v4();
  String NotificationId = Uuid().v4();

  TextEditingController commentTextEditingController = TextEditingController();

  CommentsPageState({this.comments,this.postId,this.uid,this.postImageUrl,this.timestamp,this.displayName,this.photoUrl,this.displayNamecurrentUser});
  // return Firestore.instance
  //     .collection("posts")
  //     .orderBy("timestamp", descending: true)
  //     .snapshots();





  retrieveComments(){
    print("user");
    print(displayNamecurrentUser);
    return  StreamBuilder(
      stream: CommentsRefrence.document(postId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot){
        if (!dataSnapshot.hasData){
          return Container(
            color: Colors.white,
          );
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,

        );
      },
    );
  }

  bool errordikhaoC = false;

//   String commentValidator(String value) {
//     if (value.length == null) {
// //      return 'Password must be longer than 8 characters';
//       setState(() {
//         errordikhaoC = true;
//       });
//     } else {
//       setState(() {
//         errordikhaoC = false;
//       });
//     }
//   }




  //setData({'liked': userEmail});

  var commentCount = 0;

  // CommentCount() async {
  //   return StreamBuilder(
  //     stream: CommentsRefrence.document(postId)
  //         .snapshots(),
  //     builder: (context, dataSnapshot) {
  //        commentCount = 'comments';
  //       }


  //   );
  // }

  SaveCommentI() async {
    return await Firestore.instance
        .collection("posts")
        .document(postId)
        .updateData({'comments': comments + commentCount});
  }

  showError(){
    setState(() {
      errordikhaoC = true;
    });
    return AlertDialog(
      content: Text(
        'Insert something',
        style: TextStyle(color: Colors.black),
      ),
      title: Text("Error !", style:
      TextStyle(color: Colors.red),),
    );
  }

  Notification() async {
    //print(currUid);

    setState(() {
      // file = null;
      NotificationId = Uuid().v4();
    });

    return await Firestore.instance.collection("users")
        .document(uid).collection("notification")
        .document(NotificationId)
        .setData({"commentId" : CommentId,
      "notificationId" : NotificationId,
      "username": displayNamecurrentUser,
      "comment": commentTextEditingController.text,

      "timestamp": DateTime.now(),
      "url": photoUrl,
      "uid": uid,
      "status" : "Comment",
      "postId" : postId,
    });

  }

  SaveCommentIP() async {
    return await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("posts")
        .document(postId)
        .updateData({'comments': comments + 1});
  }

  saveComment() async {
    print("comm");
    print(commentCount);
    setState(() {
      // file = null;
      CommentId = Uuid().v4();
    });
    setState(() {
      errordikhaoC = false;
    });
    // print(postId);
    // print("ehllo");


    await CommentsRefrence.document(postId).collection("comments").document(CommentId)
        .setData({"commentId" : CommentId,
      "username": displayNamecurrentUser,
      "comment": commentTextEditingController.text,

      "timestamp": DateTime.now(),
      "url": photoUrl,
      "uid": uid,
    });






    bool isNotPostOwner = uid != uid;
    if(isNotPostOwner){
      CommentsRefrence.document(postId).collection("feedItems").add({
        "type": "comment",
        "commentDate": timestamp,
        "postId": postId,
        "username": displayNamecurrentUser,
        "userProfileImg": photoUrl,
        "url": postImageUrl,
      });
    }
    commentTextEditingController.clear();

    return StreamBuilder(

        stream: CommentsRefrence.document(postId).snapshots(),
        builder: (context, dataSnapshotX)
        {
          int commentscount = dataSnapshotX.data["comments"];
          updatecommentscount(commentscount);

          return (dataSnapshotX.hasData)?
          Container(
            color: Colors.white,
          ):Container();
        }
    );



  }

  updatecommentscount(int commentscount){
    print("oichhh!!1");
    print(commentscount);

    CommentsRefrence.document(postId).updateData({"comments": commentscount + 1});

  }

  @override
  void initState() {

    retrieveComments();

  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Comments", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.normal),),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,), onPressed: (){
            Navigator.pop(context);
          }),
        ),
        //appBar: header(context, strTitle: "Comments"),

        body: Column(
          children: [
            Expanded(
              child: retrieveComments(),
            ),

            ListTile(
              key: _CommentKey,
              title: TextFormField(
                controller: commentTextEditingController,
                //validator: commentValidator,
                decoration: InputDecoration(
                    labelText: (errordikhaoC)?"insert proper comment":"Write Comment Here...",
                    labelStyle: TextStyle(color: (errordikhaoC)?Colors.red:Colors.black),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: (errordikhaoC)?Colors.red:Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: (errordikhaoC)?Colors.red:Colors.black))
                ),
                style: TextStyle(color: Colors.black),
              ),
              trailing:IconButton(
                onPressed: (){
                  if(commentTextEditingController.text != "" && commentTextEditingController.text.length < 100){
                    setState(() {
                      errordikhaoC = false;
                    });
                    commentCount = commentCount + 1;
                    saveComment();
                    SaveCommentI();
                    SaveCommentIP();
                    Notification();
                  }else{
                    showError();
                    print("error hai bhaiya");
                  }

//                retrieveComments();
                },

                icon: Icon(Icons.arrow_forward_ios,size: 30.0,color: Colors.deepPurple,),
                //child: Text("Publish", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        )

    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;

  Comment({this.userName,this.userId,this.url,this.comment,this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot){
    return Comment(
      userName: documentSnapshot["username"],
      userId: documentSnapshot["uid"],
      url: documentSnapshot["url"],
      comment: documentSnapshot["comment"],
      timestamp: documentSnapshot["timestamp"],

    );
  }

  String tAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: 0.0),
      child: Container(

        color: Colors.white,

            child: Stack(
              children: [
                ListTile(
                  title: (userName != null || comment != null)?Row(
                    children: [
                      Container(
                        width: deviceWidth*0.65,
                        child: Expanded(
                          child: RichText(
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: userName + " :  ",
                                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold,),
                                ),
                                TextSpan(
                                  text: comment,
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),

//                      Text(userName + " :",style: TextStyle(fontSize: 18.0,color: Colors.black,
//                        fontWeight: FontWeight.bold,),),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 2.0),
//                        child: Expanded(
//                          //width: 170.0,
//                          child: SizedBox(
//                            width: 108.0,
//                            child: Text(comment,style: TextStyle(fontSize: 15.0,color: Colors.black,
//                            ),),
//                          ),
//                        ),
//                      ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {

                        },
                      ),
                    )
                    ],
                  ):Text(""),
                  leading: (userName != null || comment != null)?CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(url),
                  ):null,
                  subtitle: (userName != null || comment != null)?Text(tAgo(timestamp.toDate()),style: TextStyle(color: Colors.grey),):Text(""),
                ),
              ],
            ),

      ),

    );
  }
}


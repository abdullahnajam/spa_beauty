import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({Key? key}) : super(key: key);

  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  void back(){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(back,"Invite Friends"),
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  image:DecorationImage(
                      image: AssetImage('assets/images/invite.png'),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      FirebaseFirestore.instance.collection('settings').doc("share").get().then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                          Share.share('Get your spa service from ${data['playStore']}');
                        }
                      });

                    },
                    leading: Image.asset('assets/images/playstore.png',scale: 20,),
                    title:Text("Play Store"),
                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                  ),
                  ListTile(
                    onTap: (){
                      String? url;
                      FirebaseFirestore.instance.collection('settings').doc("share").get().then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                          url=data['appStore'];

                        }
                      }).then((value) =>Share.share('Get your spa service from $url') );


                    },
                    leading: Image.asset('assets/images/appstore.png',scale: 20,),
                    title:Text("App Store"),
                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

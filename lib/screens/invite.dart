import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(

          //color:Colors.transparent.withOpacity(0.2),
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image:AssetImage("assets/images/pattern.jpg",),
                fit: BoxFit.fitHeight

            )
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(back,'inviteFriend'.tr()),
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
                            FirebaseFirestore.instance.collection('settings').doc('points').get().then((DocumentSnapshot pointSnapshot) {
                              if (pointSnapshot.exists) {
                                Map<String, dynamic> point = pointSnapshot.data() as Map<String, dynamic>;
                                FirebaseFirestore.instance
                                    .collection('customer')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get()
                                    .then((DocumentSnapshot userSnap) {
                                  if (userSnap.exists) {
                                    Map<String, dynamic> user = userSnap.data() as Map<String, dynamic>;
                                    int points=user['points']+point['share'];
                                    FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      'points': points,
                                    }).onError((error, stackTrace){
                                      final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }
                                }).onError((error, stackTrace){
                                  final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });

                              }
                            }).onError((error, stackTrace){
                              final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            });
                          }
                        });

                      },
                      leading: Image.asset('assets/images/playstore.png',scale: 20,),
                      title:Text('playStore'.tr()),
                      trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                    ),
                    ListTile(
                      onTap: (){
                        String? url;
                        FirebaseFirestore.instance.collection('settings').doc("share").get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                            url=data['appStore'];
                            FirebaseFirestore.instance.collection('settings').doc('points').get().then((DocumentSnapshot pointSnapshot) {
                              if (pointSnapshot.exists) {
                                Map<String, dynamic> point = pointSnapshot.data() as Map<String, dynamic>;
                                FirebaseFirestore.instance
                                    .collection('customer')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get()
                                    .then((DocumentSnapshot userSnap) {
                                  if (userSnap.exists) {
                                    Map<String, dynamic> user = userSnap.data() as Map<String, dynamic>;
                                    int points=user['points']+point['share'];
                                    FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      'points': points,
                                    }).onError((error, stackTrace){
                                      final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }
                                }).onError((error, stackTrace){
                                  final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });

                              }
                            }).onError((error, stackTrace){
                              final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            });

                          }
                        }).then((value) =>Share.share('Get your spa service from $url') );


                      },
                      leading: Image.asset('assets/images/appstore.png',scale: 20,),
                      title:Text('appStore'.tr()),
                      trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

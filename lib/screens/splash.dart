import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/screens/home_page.dart';
import 'package:spa_beauty/screens/select_gender.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/utils/sharedPref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;
  SharedPref sharedPref=new SharedPref();
  bool isImageLoaded=false;
  String imageUrl="";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('settings')
        .doc('app_data')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          imageUrl=data['splash'];
        });
      }
    });
    sharedPref.setPopupPref(true);
    _loadWidget();
  }
  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if(FirebaseAuth.instance.currentUser==null)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender("Home")));
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl==""?CircularProgressIndicator():Image.network(imageUrl,width: 150,height: 150,),
            ],
          )),
          decoration: BoxDecoration(
            color: Colors.white
          )
      ),
    );
  }
}


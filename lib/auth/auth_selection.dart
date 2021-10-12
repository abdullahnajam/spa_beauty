import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/auth/google_signIn.dart';
import 'package:spa_beauty/auth/login.dart';
import 'package:spa_beauty/auth/register.dart';
import 'package:spa_beauty/utils/constants.dart';

import 'facebook_signIn.dart';
import 'package:easy_localization/easy_localization.dart';
class AuthSelection extends StatefulWidget {
  const AuthSelection({Key? key}) : super(key: key);

  @override
  _AuthSelectionState createState() => _AuthSelectionState();
}

class _AuthSelectionState extends State<AuthSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: imageUrl==""?CircularProgressIndicator():Image.network(imageUrl,fit: BoxFit.cover,),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => Login()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          darkBrown,
                          lightBrown,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(12),
                    child:Text('login'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => Register()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          darkBrown,
                          lightBrown,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(12),
                    child:Text('registerBtn'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 25,
                        child: Divider(color: Colors.grey,),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Text('orWith'.tr(),style: TextStyle(color: Colors.grey),),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: 25,
                        child: Divider(color: Colors.grey,),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FacebookSignIn(),
                      GoogleSignin(),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
          imageUrl=data['auth'];
        });
      }
    });
  }
}

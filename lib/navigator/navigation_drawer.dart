import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/screens/all_categories.dart';
import 'package:spa_beauty/screens/appointments.dart';
import 'package:spa_beauty/screens/coupons.dart';
import 'package:spa_beauty/screens/favourites.dart';
import 'package:spa_beauty/screens/home_page.dart';
import 'package:spa_beauty/screens/my_account.dart';
import 'package:spa_beauty/screens/offers.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {

  _showChangeLanguageDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('changeLanguage'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('ar', 'EG');

                  },
                  title: Text('arabic'.tr()),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                  },
                  title: Text("English"),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }
  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Container(height: 8),
              FirebaseAuth.instance.currentUser!=null?
              InkWell(
                onTap: (){
                  FirebaseFirestore.instance
                      .collection('customer')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {

                      Navigator.pushReplacement(context, new MaterialPageRoute(
                          builder: (context) => MyAccount()));
                    }
                  });

              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_outline, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("My Account", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ):
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, new MaterialPageRoute(
                      builder: (context) => AuthSelection()));
                },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.vpn_key_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Sign In", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) => Offers()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Offers", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
               _showChangeLanguageDailog();
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('changeLanguage'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) => Coupons()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Coupons", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => AllCategories()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.apps, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Categories", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => AllCategories()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_call, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("Support", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => AllCategories()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.assignment, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text("About", style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),



            ],
          ),
        )
      ),
    );
  }
}

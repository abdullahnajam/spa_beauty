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
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/values/constants.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


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
                Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) => MyAccount()));
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



            ],
          ),
        )
      ),
    );
  }
}

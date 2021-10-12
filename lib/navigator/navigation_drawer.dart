import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/user_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/screens/About.dart';
import 'package:spa_beauty/screens/all_categories.dart';
import 'package:spa_beauty/screens/all_services_list.dart';
import 'package:spa_beauty/screens/appointments.dart';
import 'package:spa_beauty/screens/coupons.dart';
import 'package:spa_beauty/screens/favourites.dart';
import 'package:spa_beauty/screens/home_page.dart';
import 'package:spa_beauty/screens/my_account.dart';
import 'package:spa_beauty/screens/offers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_beauty/utils/dark_mode.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
                  },
                  title: Text("عربى"),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context) => BottomBar()));
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


  Future<String> getSideBarImage()async{
    String sideBarUrl="";
    await FirebaseFirestore.instance.collection('settings').doc('app_data').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          sideBarUrl=data['sideBar'];
        });
      }
    });
    print("side bar image $sideBarUrl");
    return sideBarUrl;
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: FutureBuilder<String>(
                  future: getSideBarImage(),
                  builder: (context,shot){
                    if (shot.hasData) {
                      if (shot.data != null) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(shot.data.toString()),
                                  fit: BoxFit.cover
                              )
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("no data")
                          ),
                        );
                      }
                    }
                    else if (shot.hasError) {
                      return Text('Error : ${shot.error}');
                    } else {
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              /*sideBarUrl==""?Center(child: CircularProgressIndicator(),):Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(sideBarUrl),
                        fit: BoxFit.cover
                    )
                ),
              ),*/
              Container(height: 8),

              FirebaseAuth.instance.currentUser!=null  ?
              InkWell(
                onTap: (){

                  print(FirebaseAuth.instance.currentUser!.uid);
                  if (GoogleSignIn().currentUser != null)
                    {
                      FirebaseFirestore.instance
                          .collection('customer')
                          .doc(GoogleSignIn().currentUser!.id)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                          UserModel user=UserModel.fromMap(data, documentSnapshot.reference.id);
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => MyAccount()));
                        }

                      });

                    }
                  else
                    {
                      print("all ok");
                      FirebaseFirestore.instance
                          .collection('customer')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                          UserModel user=UserModel.fromMap(data, documentSnapshot.reference.id);
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => MyAccount()));
                        }
                        else {

                        }
                      });
                    }



              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_outline, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('myAccount'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ):
              InkWell(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => AuthSelection()));
                },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.vpn_key_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('signin'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),

              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => AllCategories()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.assignment_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('bookNow'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),

              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Offers()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('offers'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Favourites()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('favourite'.tr(), style: TextStyle(color: Colors.grey))),
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
                      Icon(Icons.translate, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('changeLanguage'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),

              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Appointments()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.assignment_turned_in, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('appointments'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),


              Container(height: 10),
              InkWell(onTap: (){
                FirebaseFirestore.instance
                    .collection('about')
                    .doc('data')
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                    FlutterOpenWhatsapp.sendSingleMessage(data['contact'], "Book a service from Hammam spa & beauty app");
                  } else {
                    print('Document does not exist on the database');
                  }
                });

              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_call, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('support'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => About()));
              },
                child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.assignment, color: Colors.grey, size: 20),
                      Container(width: 20),
                      Expanded(child: Text('about'.tr(), style: TextStyle(color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              /*Container(height: 10),
              Container(height: 50, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: [

                          Icon(Icons.wb_sunny, color: Colors.grey, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('theme'.tr(), style: TextStyle(color: Colors.grey))),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      child: DayNightSwitcher(
                        isDarkModeEnabled: themeChange.darkTheme,
                        onStateChanged: (isDarkModeEnabled) {
                          setState(() {
                            themeChange.darkTheme = isDarkModeEnabled;
                          });
                        },
                      ),
                    ),

                  ],
                ),
              ),*/



            ],
          ),
        )
      ),
    );
  }




}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/user_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/invite.dart';
import 'package:spa_beauty/screens/notifications.dart';
import 'package:spa_beauty/screens/privacy_policy.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class MyAccount extends StatefulWidget {
  

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  bool dataLoading=true;
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(_openDrawer,"My Account"),

            dataLoading?
            Center(
              child: Lottie.asset('assets/json/loading.json',width: 150,height: 150),
            ):
            user!=null?Container(
              height: MediaQuery.of(context).size.height*0.85,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        InkWell(
                          child: Container(
                            height: 80,
                            width: 80,
                            child: CircleAvatar(
                              child: Image.network(user!.profilePicture),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(user!.username,style:  Theme.of(context).textTheme.headline6!.apply(color: Colors.black),),
                        ),
                        Container(
                          child: Text(user!.email,style:  TextStyle(color: Colors.grey),),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)
                              ),

                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.credit_card_outlined,color: Colors.white,),
                                    ),
                                    title:Text("Wallet"),
                                    trailing: Text("0",style: TextStyle(color: lightBrown),),

                                  ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.person_outlined,color: Colors.white,),
                                    ),
                                    title:Text("Account Information"),
                                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                                  ),
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)
                              ),

                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: (){
                                      Navigator.push(context, new MaterialPageRoute(builder: (context) => Notifications()));
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.notifications_active_outlined,color: Colors.white,),
                                    ),
                                    title:Text("Notifications"),
                                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                                  ),
                                  ListTile(
                                    onTap: (){
                                      Navigator.push(context, new MaterialPageRoute(builder: (context) => InviteFriend()));
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.person_add_alt,color: Colors.white,),
                                    ),
                                    title:Text("Invite Friend"),
                                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),
                                  ),
                                  /*ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.settings,color: Colors.white,),
                                    ),
                                    title:Text("Settings"),
                                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                                  ),*/
                                  ListTile(
                                    onTap: (){
                                      Navigator.push(context, new MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: darkBrown,
                                      child: Icon(Icons.card_travel_sharp,color: Colors.white,),
                                    ),
                                    title:Text('privacy'.tr()),
                                    trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                                  ),
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7)
                            ),

                            child: ListTile(
                              onTap: (){
                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
                                });
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Icon(Icons.logout,color: Colors.black,),
                              ),
                              title:Text("Log Out"),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/nouser.json',width: 150,height: 150),
                Container(
                  alignment: Alignment.center,
                  child: Text("You are currently not logged In",style: TextStyle(fontSize: 20),),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AuthSelection()));
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
                    child:Text("LOGIN",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                  ),
                )

              ],
            ),

          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();

      FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        user=UserModel.fromMap(data, documentSnapshot.reference.id);
        setState(() {
          dataLoading=false;
        });
      }
    });
   
  }
}

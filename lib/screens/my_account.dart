import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
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

            Container(
              width: double.maxFinite,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Container(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                      child: Text("Image"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text("John Doe",style:  Theme.of(context).textTheme.headline6!.apply(color: Colors.black),),
                  ),
                  Container(
                    child: Text("usermail@mail.com",style:  TextStyle(color: Colors.grey),),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Expanded(
              child: ListView(
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
                              title:Text("Payment Methods"),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey,),

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
                              leading: CircleAvatar(
                                backgroundColor: darkBrown,
                                child: Icon(Icons.notifications_active_outlined,color: Colors.white,),
                              ),
                              title:Text("Notifications"),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: darkBrown,
                                child: Icon(Icons.person_add_alt,color: Colors.white,),
                              ),
                              title:Text("Invite Friend"),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey,),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: darkBrown,
                                child: Icon(Icons.settings,color: Colors.white,),
                              ),
                              title:Text("Settings"),
                              trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: darkBrown,
                                child: Icon(Icons.card_travel_sharp,color: Colors.white,),
                              ),
                              title:Text("Terms and Service"),
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
            )

          ],
        ),
      )
    );
  }
}

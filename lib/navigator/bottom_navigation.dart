import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spa_beauty/screens/appointments.dart';
import 'package:spa_beauty/screens/favourites.dart';
import 'package:spa_beauty/screens/home_page.dart';
import 'package:spa_beauty/screens/my_account.dart';
import 'package:spa_beauty/screens/notifications.dart';
import 'package:spa_beauty/values/constants.dart';

class BottomBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomBar>{


  int _currentIndex = 2;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
  /*  UserModel user;

    FirebaseFirestore.instance
        .collection('customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        user=UserModel.fromMap(data, documentSnapshot.reference.id);
      }
    });*/

    _children = [
      MyAccount(),
      Favourites(),
      HomePage(),
      Appointments(),
      Notifications(),

    ];

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Color(0xffF0F0F0),
        index: 2,
        color: lightBrown,
        items: <Widget>[
          Icon(Icons.account_circle_outlined,color: Colors.white, size: 30),
          Icon(Icons.favorite,color: Colors.white, size: 30),
          Icon(Icons.home,color: Colors.white, size: 30),
          Icon(Icons.calendar_today,color: Colors.white, size: 30),
          Icon(Icons.notifications,color: Colors.white, size: 30),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        },
      ),
      body: _children[_currentIndex],
    );
  }




}

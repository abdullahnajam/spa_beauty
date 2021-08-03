import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/auth/google_signIn.dart';
import 'package:spa_beauty/auth/login.dart';
import 'package:spa_beauty/auth/register.dart';
import 'package:spa_beauty/values/constants.dart';

import 'facebook_signIn.dart';
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
            child: Image.asset('assets/images/placeholder.png',fit: BoxFit.cover,),
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
                    child:Text("LOGIN",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
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
                    child:Text("REGISTER",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
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
                        child: Text("OR WITH",style: TextStyle(color: Colors.grey),),
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class FacebookSignIn extends StatefulWidget {
  @override
  _FacebookSignInState createState() => _FacebookSignInState();
}

class _FacebookSignInState extends State<FacebookSignIn> {
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  FacebookLogin facebookLogin = FacebookLogin();


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () async{
        await handleLogin();
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(40),

          ),
          alignment: Alignment.center,
          margin: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/facebook.png',width: 30,height: 30,),
              SizedBox(width: 5,),
              Text("FACEBOOK",style: TextStyle(color: Colors.blueAccent,fontSize: 17,fontWeight: FontWeight.w400),),
            ],
          )
      ),
    );
  }


  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
    FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    setState(() {
      isSignIn = true;
      _user = a.user!;
    });
  }

  Future<void> facebookSignout() async {
    await _auth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
        isSignIn = false;
      });
    });
  }






}




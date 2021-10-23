import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/auth/register.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'auth_selection.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  final _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var changeEmailController=TextEditingController();
  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text("A mail has been sent to you. Please check your mail for reset password link"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showForgotPasswordDialog() async {
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text('forgotPassword'.tr(),textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: darkBrown),),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10),

                            ),
                          )
                        ],
                      ),

                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'email'.tr(),
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: darkBrown),
                                ),
                                TextFormField(
                                  controller: changeEmailController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: lightBrown,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: lightBrown,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: lightBrown,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),



                            SizedBox(height: 15,),
                            InkWell(
                              onTap: ()async{
                                if (_formKey.currentState!.validate()) {
                                  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                  await firebaseAuth.sendPasswordResetEmail(email: changeEmailController.text.trim()).whenComplete((){
                                    _showPasswordDialog();
                                  }).catchError((onError){
                                    print(onError.toString());

                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                color: darkBrown,
                                alignment: Alignment.center,
                                child: Text('changePassword'.tr(),style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBrown,
        body: SafeArea(
          child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back,color: Colors.white,),
                          ),
                          SizedBox(width: 5,),
                          Text('signin'.tr(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),)
                        ],
                      )
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.89,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                      ),

                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: darkBrown,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                            color: darkBrown,
                                            width: 0.5
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: darkBrown,
                                          width: 0.5,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.email_outlined,color: darkBrown,size: 22,),
                                      hintText: 'enterEmail'.tr(),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: darkBrown,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                            color: darkBrown,
                                            width: 0.5
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: darkBrown,
                                          width: 0.5,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.lock_outline,color: darkBrown,size: 22,),
                                      hintText: 'enterPassword'.tr(),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: () async{
                                    final ProgressDialog pr = ProgressDialog(context: context);
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        pr.show(max: 100, msg: "Please wait");
                                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password: passwordController.text
                                        ).then((value) {
                                          pr.close();
                                          final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                                          _firebaseMessaging.subscribeToTopic('customer');
                                          _firebaseMessaging.getToken().then((value) {
                                            FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                              'token': value,
                                              'topic': 'customer',
                                            });
                                          });
                                          print("usrId ${value.user!.uid}");
                                          FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
                                            if (documentSnapshot.exists) {
                                              Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                              if(data['status']=="Active"){
                                                print("active");
                                                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => BottomBar()));
                                              }
                                              else{
                                                print("disabled");
                                                FirebaseAuth.instance.signOut();
                                                final snackBar = SnackBar(content: Text("This user is blocked by admin"));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                              }

                                            }
                                            else{
                                              FirebaseAuth.instance.signOut();
                                              final snackBar = SnackBar(content: Text("This user doesnot exists"));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          });

                                        });
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          pr.close();
                                          print('No user found for that email.');
                                          final snackBar = SnackBar(content: Text("No user found for that email"));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        } else if (e.code == 'wrong-password') {
                                          pr.close();
                                          print('Wrong password provided for that user.');
                                          final snackBar = SnackBar(content: Text("Wrong password provided for that user"));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                        else{
                                          final snackBar = SnackBar(content: Text(e.message.toString()));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      }
                                    }
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
                                    child:Text('login'.tr(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        _showForgotPasswordDialog();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(12, 0,12, 0),
                                        child: Text('forgotPassword'.tr(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.black),),
                                      ),
                                    )
                                  ],
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
                                      InkWell(
                                        onTap: (){

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
                                      ),
                                      InkWell(
                                        onTap: (){

                                        },
                                        child: Container(
                                            height: 50,
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.red),
                                              borderRadius: BorderRadius.circular(40),

                                            ),
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/images/google.png',width: 30,height: 30,),
                                                SizedBox(width: 5,),
                                                Text("GOOGLE",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.w400),),
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('already'.tr()),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.pushReplacement(context, new MaterialPageRoute(
                                              builder: (context) => Register()));
                                        },
                                        child: Text('registerBtn'.tr(),style: TextStyle(color: darkBrown,fontWeight: FontWeight.w600),),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )
          ),
        )
    );
  }
}

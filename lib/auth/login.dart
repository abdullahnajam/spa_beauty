import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/auth/register.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/values/constants.dart';

import 'auth_selection.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
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
                          Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),)
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
                                      hintText: "Enter your email",
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
                                      hintText: "Enter your password",
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
                                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => BottomBar()));

                                        });
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          pr.close();
                                          print('No user found for that email.');
                                        } else if (e.code == 'wrong-password') {
                                          pr.close();
                                          print('Wrong password provided for that user.');
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
                                    child:Text("LOGIN",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
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
                                      Text("Don't have an account?"),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.pushReplacement(context, new MaterialPageRoute(
                                              builder: (context) => Register()));
                                        },
                                        child: Text("REGISTER",style: TextStyle(color: darkBrown,fontWeight: FontWeight.w600),),
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

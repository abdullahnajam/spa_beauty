import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';

import 'login.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
  var dobController=TextEditingController();
  var passwordController=TextEditingController();
  var genderController=TextEditingController();
  var firstnameController=TextEditingController();
  var lastnameController=TextEditingController();
  var phoneNumberController=TextEditingController();

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
                          Text('signup'.tr(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),)
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

                      child: ListView(
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10,right: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: firstnameController,
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
                                      prefixIcon: Icon(Icons.person_outline,color: darkBrown,size: 22,),
                                      hintText: 'firstName'.tr(),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5,right: 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: lastnameController,
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
                                      prefixIcon: Icon(Icons.person_outline,color: darkBrown,size: 22,),
                                      hintText: 'lastName'.tr(),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phoneNumberController,
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
                                prefixIcon: Icon(Icons.phone_outlined,color: darkBrown,size: 22,),
                                hintText: 'enterPhone'.tr(),
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
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: TextFormField(
                              readOnly: true,
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return StatefulBuilder(
                                        builder: (context,setState){
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
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context).size.width*0.3,
                                              child: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection('genders').snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Column(
                                                        children: [
                                                          Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                          Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.data!.size==0){
                                                    return Center(
                                                        child: Text("No Genders Added",style: TextStyle(color: Colors.black))
                                                    );

                                                  }

                                                  return new ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                      return new Padding(
                                                        padding: const EdgeInsets.only(top: 15.0),
                                                        child: ListTile(
                                                          onTap: (){
                                                            setState(() {
                                                              genderController.text="${data['gender']}";
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          leading: CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage: NetworkImage(data['image']),
                                                            backgroundColor: Colors.indigoAccent,
                                                            foregroundColor: Colors.white,
                                                          ),
                                                          title: Text("${data['gender']}",style: TextStyle(color: Colors.black),),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                );
                              },
                              controller: genderController,
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
                                prefixIcon: Icon(Icons.male_outlined,color: darkBrown,size: 22,),
                                hintText:'enterGender'.tr(),
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
                              inputFormatters: [
                                MultiMaskedTextInputFormatter(
                                    masks: ['xx-xx-xxxx'], separator: '-')
                              ],
                              controller: dobController,
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
                                prefixIcon: Icon(Icons.calendar_today,color: darkBrown,size: 22,),
                                hintText:'enterDob'.tr(),
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: ()async{
                              final ProgressDialog pr = ProgressDialog(context: context);
                              if (_formKey.currentState!.validate()) {
                                try {
                                  pr.show(max: 100, msg: "Please wait");
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text
                                  ).then((value){
                                    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                                    _firebaseMessaging.subscribeToTopic('customer');
                                    _firebaseMessaging.getToken().then((value) {
                                      FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                        'firstName': firstnameController.text,
                                        'lastName': lastnameController.text,
                                        'phone': phoneNumberController.text,
                                        'token': value,
                                        'topic': 'customer',
                                        'status':'Active',
                                        'email': emailController.text,
                                        'gender': genderController.text,
                                        'points':0,
                                        'wallet':0,
                                        'behaviourStatus':"Not Assigned",
                                        'dateOfBirth':dobController.text,
                                        'profilePicture':"https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/images%2F2021-07-27%2001%3A30%3A51.606.png?alt=media&token=50eaee1a-4878-4ad4-985a-dfdfb19ce78d"
                                      }).then((value) {
                                        pr.close();
                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => BottomBar()));
                                      }).onError((error, stackTrace){
                                        final snackBar = SnackBar(content: Text("Database Error"));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });
                                    }).onError((error, stackTrace){
                                      final snackBar = SnackBar(content: Text("Notification Token Error"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });

                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    pr.close();
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    pr.close();
                                    print('The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                  pr.close();
                                }
                                pr.close();
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
                              child:Text('registerBtn'.tr(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
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
                                Text('already2'.tr()),
                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(
                                        builder: (context) => Login()));
                                  },
                                  child: Text('login'.tr(),style: TextStyle(color: darkBrown,fontWeight: FontWeight.w600),),
                                )
                              ],
                            ),
                          )
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

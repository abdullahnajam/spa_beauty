import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/user_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/account_info.dart';
import 'package:spa_beauty/screens/invite.dart';
import 'package:spa_beauty/screens/notifications.dart';
import 'package:spa_beauty/screens/privacy_policy.dart';
import 'package:spa_beauty/screens/redeem_points.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class MyAccount extends StatefulWidget {
  

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  File? imagefile;
  void fileSet(File file){
    setState(() {
      if(file!=null){
        imagefile=file;

      }
    });
    uploadImageToFirebase(context);
  }
  _chooseGallery() async{
    await ImagePicker().getImage(source: ImageSource.gallery).then((value) => fileSet(File(value!.path)));

  }
  _choosecamera() async{
    await ImagePicker().getImage(source: ImageSource.camera).then((value) => fileSet(File(value!.path)));
  }
  String? photoUrl;
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _chooseGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _choosecamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }



  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = imagefile!.path;
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Loading");
    firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(imagefile!);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) {
        photoUrl=value;

        FirebaseFirestore.instance.collection("customer").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "profilePicture":photoUrl,
        }).then((value){
          pr.close();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyAccount()));
        });

      },
    );
  }

  Future<void> _UpdateDailog() async {
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
            height: MediaQuery.of(context).size.height*0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('editProfile'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10,top: 20),
                  child: Text('username'.tr(),textAlign: TextAlign.start,style: TextStyle(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText:"",contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10),
                  child: Text('phoneNumber'.tr(),textAlign: TextAlign.start,style: TextStyle(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(

                    controller: phoneController,
                    decoration: InputDecoration(hintText:"",contentPadding: EdgeInsets.only(left: 10)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: darkBrown,
                      onPressed: (){
                        final ProgressDialog pr = ProgressDialog(context: context);
                        pr.show(max: 100, msg: "Loading");
                        FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                          'username': usernameController.text,
                          'phone': phoneController.text,
                        }).then((value) {
                          pr.close();
                          print("added");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyAccount()));
                        });
                      },
                      child: Text('update'.tr(),style: TextStyle(color: Colors.white),),
                    )
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('changePassword'.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text('message'.tr()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  String? profileImage;
  bool dataLoading=true;
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MenuDrawer(),
      backgroundColor: Colors.grey[200],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(

          //color:Colors.transparent.withOpacity(0.2),
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image:AssetImage("assets/images/pattern.jpg",),
                fit: BoxFit.fitHeight

            )
        ),
        child: SafeArea(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.15, color: darkBrown),
                  ),
                ),
                height:  AppBar().preferredSize.height,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('myAccount'.tr()),
                    ),

                  ],
                ),
              ),

              dataLoading?
              Center(
                child: CircularProgressIndicator()
              ):
              FirebaseAuth.instance.currentUser!=null?Container(
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
                            onTap: (){
                              _showPicker(context);
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Image.network(user!.profilePicture,fit: BoxFit.cover,),
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
                          SizedBox(height: 5,),
                          Container(
                            child: Text(user!.phone,style:  TextStyle(color: Colors.grey),),
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
                                      title:Text('wallet'.tr()),
                                      trailing: Text(user!.wallet.toString(),style: TextStyle(color: lightBrown),),

                                    ),
                                    ListTile(
                                      onTap: (){
                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => RedeemPoints()));
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: darkBrown,
                                        child: Icon(Icons.monetization_on,color: Colors.white,),
                                      ),
                                      title:Text('myPoints'.tr()),
                                      trailing: Text(user!.points.toString(),style: TextStyle(color: lightBrown),),

                                    ),
                                    ListTile(
                                      onTap: (){
                                        _UpdateDailog();

                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: darkBrown,
                                        child: Icon(Icons.person_outlined,color: Colors.white,),
                                      ),
                                      title:Text('editProfile'.tr()),
                                      trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                                    ),
                                    ListTile(
                                      onTap: ()async{
                                        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                        await firebaseAuth.sendPasswordResetEmail(email: user!.email).whenComplete((){
                                          _showPasswordDialog();
                                        }).catchError((onError){
                                          print(onError.toString());
                                          final snackBar = SnackBar(content: Text(onError.toString()));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        });

                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: darkBrown,
                                        child: Icon(Icons.vpn_key_outlined,color: Colors.white,),
                                      ),
                                      title:Text('resetPassword'.tr()),
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
                                      title:Text('notification'.tr()),
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
                                      title:Text('inviteFriend'.tr()),
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
                                title:Text('logout'.tr()),
                                trailing: Icon(Icons.chevron_right,color: Colors.grey,),

                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
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
              SizedBox(height: 10,),

            ],
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();

      if(FirebaseAuth.instance.currentUser!=null){
        FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
            setState(() {
              user=UserModel.fromMap(data, documentSnapshot.reference.id);
              dataLoading=false;
              emailController.text=user!.email;
              phoneController.text=user!.phone;
              usernameController.text=user!.username;
              profileImage=user!.profilePicture;
            });
          }
        });
      }
      else{
        setState(() {
          dataLoading=false;
        });
      }

   
  }
}
var phoneController=TextEditingController();
var usernameController=TextEditingController();
var emailController=TextEditingController();
var passwordController=TextEditingController();

Future<void> _showEdit(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();
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
              width: MediaQuery.of(context).size.width*0.8,
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
                            margin: EdgeInsets.only(top: 2,bottom: 10),
                            child: Text("Edit Profile",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6!.apply(color: darkBrown),),
                          ),
                        ),
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
                                "Username",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: darkBrown),
                              ),
                              TextFormField(
                                controller: usernameController,
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
                                      color: darkBrown,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: darkBrown,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: darkBrown,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: darkBrown),
                              ),
                              TextField(
                                controller:phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: darkBrown,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: darkBrown,
                                        width: 0.5
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: darkBrown,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                ),
                              ),
                            ],
                          ),


                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Loading");
                              FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                'username': usernameController.text,
                                'phone': phoneController.text,
                              }).then((value) {
                                pr.close();
                                print("added");
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              height: 50,
                              color: darkBrown,
                              alignment: Alignment.center,
                              child: Text("Update",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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

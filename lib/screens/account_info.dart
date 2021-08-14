import 'package:flutter/material.dart';
import 'package:spa_beauty/model/user_model.dart';
import 'package:spa_beauty/values/constants.dart';

class AccountInformation extends StatefulWidget {
  UserModel user;


  AccountInformation(this.user);

  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  var phoneController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("Account Information"),
                  ),

                ],
              ),
            ),
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
                        child: Image.network(widget.user.profilePicture),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(widget.user.username,style:  Theme.of(context).textTheme.headline6!.apply(color: Colors.black),),
                  ),
                  Container(
                    child: Text(widget.user.email,style:  TextStyle(color: Colors.grey),),
                  ),
                  Container(
                    child: Text(widget.user.phone,style:  TextStyle(color: Colors.grey),),
                  ),

                  SizedBox(height: 20,),
                  Container(
                    child: Text("Edit Profile",style:  TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 18),),
                  ),
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      TextFormField(
                        controller:emailController,
                        style: TextStyle(color: Colors.black),
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
                          hintText: "Enter Coupon Code",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
                          },
                          icon: Icon(Icons.edit,color: darkBrown,),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

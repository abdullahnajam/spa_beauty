import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:spa_beauty/widget/appointment_tile.dart';
import 'package:easy_localization/easy_localization.dart';
class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int option1 = 1 , option2 = 1 ;
  String? status;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: MenuDrawer(),
      key: _drawerKey,
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
          child: FirebaseAuth.instance.currentUser!=null ?Column(
            children: [
              CustomAppBar(_openDrawer,'appointments'.tr()),

              SizedBox(
                height: size.height*0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height*0.055,
                    width: size.width*0.34,
                    child: RaisedButton(

                      color : option1 == 1 ?  lightBrown : Colors.white ,
                      textColor: option1 == 1 ?  Colors.white : Colors.black87 ,
                      child: Text('upcoming'.tr()),

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        setState(() {
                          option1 = 1 ;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.055,
                    width: size.width*0.34,
                    child: RaisedButton(
                      child: Text('past'.tr()),
                      color : option1 == 2 ?  lightBrown : Colors.white ,
                      textColor: option1 == 2 ?  Colors.white : Colors.black87 ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        setState(() {
                          option1 = 2 ;
                        });

                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height*0.025,
              ),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    SizedBox(
                      height : size.height*0.055,
                      width: size.width*0.2,
                      child: RaisedButton(
                        child: Text('all'.tr()),
                        color : option2 == 1 ?  lightBrown : Colors.white ,
                        textColor: option2 == 1 ?  Colors.white : Colors.black87 ,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          setState(() {
                            option2 = 1 ;
                          });

                        },
                      ),
                    ),

                    SizedBox(
                      height : size.height*0.055,
                      width: size.width*0.34,
                      child: RaisedButton(
                        child: option1 == 1 ? Text('Approved'.tr()) :Text('Completed'.tr()) ,
                        color : option2 == 2 ?  lightBrown : Colors.white ,
                        textColor: option2 == 2 ?  Colors.white : Colors.black87 ,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          setState(() {
                             option2 = 2 ;
                          });

                        },
                      ),
                    ),

                    SizedBox(
                      height : size.height*0.055,
                      width: size.width*0.34,
                      child: RaisedButton(
                        child: option1 == 1 ? Text('Pending'.tr()) :Text('Cancelled'.tr()),
                        color : option2 == 3 ?  lightBrown : Colors.white ,
                        textColor: option2 == 3 ?  Colors.white : Colors.black87 ,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          setState(() {
                             option2 = 3 ;
                          });
                        },
                      ),
                    ),
                  ],
                ),

              SizedBox(
                height: size.height*0.02,
              ),

              Divider(
                indent: 20,
                endIndent: 20,
                thickness: 1,
                color: lightBrown,
              ),


              //check if all is pressed
              option2 == 1 ?
                    //if all is pressed is upcoming choosed ?  true
                    option1 == 1 ? Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('appointments').where('status', whereIn: ['Approved','Pending'] )
                          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                  Text("Something Went Wrong")

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
                            return Container(
                                alignment: Alignment.center,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: lightBrown,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                                    )
                                  ],
                                )

                            );

                          }
                          return new ListView(

                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                              return AppointmentTile(model);
                            }).toList(),
                          );
                        },
                      ),
                    ) :
                    //else if all is pressed past is choosed ? true
                    option1== 2 ? Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('appointments').where('status', whereIn: ['Completed','Cancelled'] )
                            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                  Text("Something Went Wrong")

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
                            return Container(
                                alignment: Alignment.center,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: lightBrown,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                                    )
                                  ],
                                )

                            );

                          }
                          return new ListView(

                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                              return AppointmentTile(model);
                            }).toList(),
                          );
                        },
                      ),
                    ) :
                    // else if all is pressed and neither past is choosed nor upcoming
                    Text('Please Choose An Option') :
              // if all is is not pressed  is option 2 choosed  ? true
              option2 == 2 ?
                    // if approved is choosed ? true
                    option1 == 1 ? Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('appointments').where('status', isEqualTo: 'Approved' )
                            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                  Text("Something Went Wrong")

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
                            return Container(
                                alignment: Alignment.center,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: lightBrown,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                                    )
                                  ],
                                )

                            );

                          }
                          return new ListView(

                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                              return AppointmentTile(model);
                            }).toList(),
                          );
                        },
                      ),
                    ) :
                    // else is completed choosed ? true
                    option1 == 2 ?   Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('appointments').where('status', isEqualTo: 'Completed' )
                            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                  Text("Something Went Wrong")

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
                            return Container(
                                alignment: Alignment.center,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.8,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: lightBrown,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                                    )
                                  ],
                                )

                            );

                          }
                          return new ListView(

                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                              return AppointmentTile(model);
                            }).toList(),
                          );
                        },
                      ),
                    ) : Text('Please Choose An Option') :

              // else is option 3 choosed ? true
              option2 == 3 ?
               // if Pending is pressed ? true
               option1 == 1 ? Expanded(
                 child: StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance.collection('appointments').where('status', isEqualTo: 'Pending' )
                       .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (snapshot.hasError) {
                       return Center(
                         child: Column(
                           children: [
                             Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                             Text("Something Went Wrong")

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
                       return Container(
                           alignment: Alignment.center,
                           child:Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                               SizedBox(height: 10,),
                               Container(
                                 height: 50,
                                 width: MediaQuery.of(context).size.width*0.8,
                                 alignment: Alignment.center,
                                 decoration: BoxDecoration(
                                   color: lightBrown,
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                               )
                             ],
                           )

                       );

                     }
                     return new ListView(

                       children: snapshot.data!.docs.map((DocumentSnapshot document) {
                         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                         AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                         return AppointmentTile(model);
                       }).toList(),
                     );
                   },
                 ),
               ) :
               // if cancelled is pressed ? true
               option1 == 2 ? Expanded(
                 child: StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance.collection('appointments').where('status', isEqualTo: 'Cancelled' )
                       .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (snapshot.hasError) {
                       return Center(
                         child: Column(
                           children: [
                             Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                             Text("Something Went Wrong")

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
                       return Container(
                           alignment: Alignment.center,
                           child:Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('noAppointment'.tr(),style: TextStyle(fontSize: 20),),
                               SizedBox(height: 10,),
                               Container(
                                 height: 50,
                                 width: MediaQuery.of(context).size.width*0.8,
                                 alignment: Alignment.center,
                                 decoration: BoxDecoration(
                                   color: lightBrown,
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 child: Text('bookNext'.tr(),style: TextStyle(fontSize: 20,color: Colors.white),),
                               )
                             ],
                           )

                       );

                     }
                     return new ListView(

                       children: snapshot.data!.docs.map((DocumentSnapshot document) {
                         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                         AppointmentModel model= AppointmentModel.fromMap(data, document.reference.id);
                         return AppointmentTile(model);
                       }).toList(),
                     );
                   },
                 ),
               ) :
               // NO option is chossed
               Text('Please Choose An Option') : Text('Please Choose An Option')  ,



            ],
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
        ),
      ),
    );
  }
}

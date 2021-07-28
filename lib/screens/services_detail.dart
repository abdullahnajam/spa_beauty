import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class ServiceDetail extends StatefulWidget {
  ServiceModel model;

  ServiceDetail(this.model);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  IconData _iconData=Icons.favorite_border;
  Color _color=Colors.white;
  bool isFavourite = false;
  checkFavouriteFromDatabase()async{

    FirebaseFirestore.instance
        .collection('favourites')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('services')
        .doc(widget.model.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _iconData=Icons.favorite;
          _color=Colors.red;
          isFavourite=true;
        });
      }
    });

  }
  checkFavourite() async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");
    if(isFavourite){
      FirebaseFirestore.instance.collection('favourites').doc(FirebaseAuth.instance.currentUser!.uid).collection("services").doc(widget.model.id).delete().then((value) {
        setState(() {
          _iconData=Icons.favorite_border;
          _color=Colors.white;
          isFavourite=false;
          pr.close();
        });
      })
          .catchError((error, stackTrace) {
        print("inner: $error");
        pr.close();

      });
    }
    else{
      FirebaseFirestore.instance.collection('favourites').doc(FirebaseAuth.instance.currentUser!.uid).collection("services").doc(widget.model.id).set({
        'serviceId': widget.model.id,
      }).then((value) {
        setState(() {
          _iconData=Icons.favorite;
          _color=Colors.red;
          isFavourite=true;
        });
        pr.close();
      })
          .catchError((error, stackTrace) {
        print("inner: $error");
        pr.close();

      });
    }


  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height*0.33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft:Radius.circular(25) ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.model.image,
                    height: size.height*0.33,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: IconButton(
                    icon: Icon(_iconData),
                    color: _color,
                    onPressed: checkFavourite,
                  ),
                ),

                Positioned(
                  left: 20,
                  top: 40,
                  child: InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.arrow_back_ios_sharp,color:Colors.black54,size: 25,)),
                )
              ],
            ),

            SizedBox(
              height: size.height*0.02,
            ),

            DefaultTabController(
                length: 3,
                child:Column(
                  children: [
                    Container(
                      padding : EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      height: size.height*0.07,
                      decoration: BoxDecoration(
                        border: Border.all(color: darkBrown),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: lightBrown,
                        indicator : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightBrown,
                        ),
                        /*indicator:  UnderlineTabIndicator(
                          borderSide: BorderSide(width: 0.0,color: Colors.white),
                          insets: EdgeInsets.symmetric(horizontal:16.0)
                      ),*/

                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "Gallery"),
                          Tab(text: "Review"),
                        ],
                      ),

                    ),

                    Container(
                      //height of TabBarView
                      height: MediaQuery.of(context).size.height*0.465,

                      child: TabBarView(children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Service Title",style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              SizedBox(height: 5,),
                              Text(widget.model.name,style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text("Service Description",style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              SizedBox(height: 5,),
                              Text(widget.model.description,style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text("Service Price",style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              SizedBox(height: 5,),
                              Text("${widget.model.price}",style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text("Specialists",style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              Container(
                                height: 100,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('specialists').where("serviceId",isEqualTo: widget.model.id).snapshots(),
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
                                          child:Text("No Specialists")

                                      );

                                    }
                                    return new ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        //ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                                        return Container(
                                          margin: EdgeInsets.all(5),
                                          height: 100,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: AssetImage(data['image']),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            margin: EdgeInsets.all(10),
                                            child: Text(data['name'],style: TextStyle(color: Colors.white),),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('gallery').where("serviceId",isEqualTo: widget.model.id).snapshots(),
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
                                    child:Text("No Pictures")

                                );

                              }
                              return new GridView(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  //ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: CachedNetworkImage(
                                      imageUrl: data['image'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        Container(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('reviews').where("serviceId",isEqualTo: widget.model.id).snapshots(),
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
                                    child:Text("No Reviews")

                                );

                              }
                              return new ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  //ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: AssetImage(data['image']),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.all(10),
                                      child: Text(data['name'],style: TextStyle(color: Colors.white),),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),





                      ]),
                    )

                  ],

                )
            ),



          ],
        ),
      ),

      bottomNavigationBar:
      InkWell(
        onTap: (){
          print("hrer");
          if(FirebaseAuth.instance.currentUser==null){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'You are not logged in',
              desc: 'To continue with the booking please login',
              btnCancelOnPress: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceDetail(widget.model)));
              },

              btnOkOnPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AuthSelection()));

              },
            )..show();
          }
          else
            Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(widget.model)));
        },
        child: Container(
          color: lightBrown,
          height: size.height*0.09,
          child: Center(child: Text("BOOK NOW",style:TextStyle(
            color: Colors.white,
            fontSize: 22,
            //fontWeight: FontWeight.bold,
          ),)),
        ),
      ),

    );
  }

  @override
  void initState() {
    super.initState();
    checkFavouriteFromDatabase();
  }
}

import 'dart:io';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/model/review_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';


class ServiceDetail extends StatefulWidget {
  ServiceModel model;
  String Language;
  ServiceDetail(this.model,this.Language);

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

 /* Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName="";
    f.join(dir.path, filename);
    return File(pathName);
  }*/



  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                  child: InkWell(onTap: ()=>Navigator.pop(context),child: CircleAvatar(
                    child: Icon(Icons.arrow_back_ios_sharp,color:Colors.white,size: 25,),
                  )),
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
                          Tab(text: 'description'.tr()),
                          Tab(text: 'Gallery'.tr()),
                          Tab(text: 'Review'.tr()),
                        ],
                      ),

                    ),

                    Container(
                      //height of TabBarView
                      height: MediaQuery.of(context).size.height*0.465,

                      child: TabBarView(children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(right: 10),
                          child: ListView(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('serviceTitle'.tr(),style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                  ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.share_outlined),
                                    onPressed: (){
                                      Share.share('${widget.model.name}');
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 5,),
                              Text(widget.Language=="English"?widget.model.name:widget.model.name_ar,style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text('rating'.tr(),style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              RatingBar(
                                initialRating: widget.model.rating.toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star,color: darkBrown),
                                  half: Icon(Icons.star_half,color: darkBrown),
                                  empty:Icon(Icons.star_border,color: darkBrown,),
                                ),
                                ignoreGestures: true,
                                itemSize: 15,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              SizedBox(height: 10,),
                              Text('serviceDescription'.tr(),style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              SizedBox(height: 5,),
                              Text(widget.Language=="English"?widget.model.description:widget.model.description_ar,style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text('servicePrice'.tr(),style: TextStyle(
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
                              Text('specialist'.tr(),style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.1,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('specialists')
                                      //.where("serviceIds",arrayContains: widget.model.id)
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Text("Something Went Wrong",style: TextStyle(color: Colors.black),)

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
                                          child:Text('noSpecialist'.tr(),style: TextStyle(color: Colors.black),)

                                      );

                                    }
                                    return new ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        return Container(
                                          height: MediaQuery.of(context).size.height*0.1,
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
                            stream: FirebaseFirestore.instance.collection('reviews')
                                .where("serviceId",isEqualTo: widget.model.id)
                                .where("status",isEqualTo: "Approved").snapshots(),
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
                                  ReviewModel model= ReviewModel.fromMap(data, document.reference.id);
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(10),

                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10)
                                              )
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(model.username,style: TextStyle(fontWeight: FontWeight.w600),),
                                              RatingBar(
                                                initialRating: model.rating.toDouble(),
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                ratingWidget: RatingWidget(
                                                  full: Icon(Icons.star,color: darkBrown),
                                                  half: Icon(Icons.star_half,color: darkBrown),
                                                  empty:Icon(Icons.star_border,color: darkBrown),
                                                ),
                                                ignoreGestures: true,
                                                itemSize: 14,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              )
                                            ],
                                          )
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(model.review),
                                        )
                                      ],
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
          if(FirebaseAuth.instance.currentUser==null){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'You are not logged in',
              desc: 'To continue with the booking please login',
              btnCancelOnPress: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ServiceDetail(widget.model,widget.Language)));
              },

              btnOkOnPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AuthSelection()));

              },
            )..show();
          }
          else
            Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(widget.model,false,"")));
        },
        child: Container(
          color: lightBrown,
          height: size.height*0.09,
          child: Center(child: Text('bookNow'.tr(),style:TextStyle(
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
    print("id ${widget.model.id}");
    checkFavouriteFromDatabase();
    //var myFile = file("myFileName.png");
  }
}

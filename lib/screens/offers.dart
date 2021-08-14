import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/offer_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  Future<void> _showConfirmDialog(String id) async {
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
                height: MediaQuery.of(context).size.height*0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Services",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6!.apply(color: Colors.grey),),
                          ),
                        ),

                      ],
                    ),

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('offer_service').where("offerId",isEqualTo: id ).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> offershot) {
                          print("offer ${id}");
                          if (offershot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                  Text("Something Went Wrong")

                                ],
                              ),
                            );
                          }
                          if (offershot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (offershot.data!.size==0){
                            return Container(
                                alignment: Alignment.center,
                                child:Text("No Services")

                            );

                          }
                          return new ListView(
                            shrinkWrap: true,
                            children: offershot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> serviceOffered = document.data() as Map<String, dynamic>;
                              //AboutModel model= AboutModel.fromMap(data, document.reference.id);
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Text(serviceOffered['name'],style: TextStyle(color:Colors.black,fontSize: 12,fontWeight: FontWeight.w200),),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              CustomAppBar(_openDrawer, 'offers'.tr()),
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('offers').snapshots(),
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
                          child:Text("No Offers")

                      );

                    }
                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        OfferModel model= OfferModel.fromMap(data, document.reference.id);
                        return new Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InkWell(
                              onTap: (){
                                ServiceModel model2=new ServiceModel(
                                  model.id,
                                  model.name,
                                  "",
                                    "",
                                  "",
                                  false,
                                  "",
                                    "",
                                    "",
                                    "",
                                    0,
                                  model.discount,
                                  0,
                                    "",
                                  true,
                                  0,
                                    "",
                                );
                                Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(model2,true)));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),

                                  margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: model.image,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                              SizedBox(height: 5,),
                                              Text("Price",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                              Text(data['discount'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200),),
                                              SizedBox(height: 5,),

                                              InkWell(
                                                onTap: (){
                                                  _showConfirmDialog(model.id);
                                                },
                                                child:  Text("View Services",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(data['endDate'],style: TextStyle(color: red),),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  child: Text("Details",style: TextStyle(color: Colors.transparent),),
                                                ),
                                                Icon(Icons.keyboard_arrow_down_sharp,color: Colors.transparent,)
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            )
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

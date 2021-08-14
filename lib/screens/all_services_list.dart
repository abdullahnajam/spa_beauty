import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class AllServices extends StatefulWidget {

  @override
  _AllServicesState createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: MenuDrawer(),
      key: _drawerKey,
      body: SafeArea(
        child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(_openDrawer, 'services'.tr()),
              Container(

                margin: EdgeInsets.all(10),
                child: Text('findTheBestService'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search),
                    SizedBox(
                      width: 5,
                    ),
                    Text('search'.tr())
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('services').snapshots(),
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
                      return Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                            Text("No Service Added")

                          ],
                        ),
                      );

                    }
                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                        return new Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InkWell(
                              onTap: (){
                                String languageCode=context.locale.toLanguageTag().toString();
                                languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
                                if(languageCode=="US")
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => ServiceDetail(model,'English')));
                                else
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => ServiceDetail(model,'Arabic')));

                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(data['image']),
                                            fit: BoxFit.cover
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                        SizedBox(height: 10,),
                                        Text("\$${data['price']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                        RatingBar(
                                          initialRating: data['rating'].toDouble(),
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
                                      ],
                                    ),
                                    SizedBox(width: 20,)
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}

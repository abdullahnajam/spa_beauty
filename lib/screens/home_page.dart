import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/select_gender.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/search/search_service.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color:Colors.transparent.withOpacity(0.8),
            image: DecorationImage(
                image:AssetImage("assets/images/pattern.jpg",),
                fit: BoxFit.fitHeight

            )
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.45,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            darkBrown,
                            lightBrown,
                          ],
                        ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                    ),
                  ),
                  Container(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5,),
                                    Icon(Icons.place,color: Colors.white,),
                                    Text('location'.tr(),style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.white),)
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.menu,color: Colors.white,),
                                  onPressed: _openDrawer,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: ()async{
                                      List<ServiceModel> services=[];
                                      FirebaseFirestore.instance.collection('services').get().then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          ServiceModel model=new ServiceModel(
                                              doc.reference.id,
                                              doc['name'],
                                              doc['image'],
                                            doc['gender'],
                                            doc['categoryName'],
                                            doc['categoryId'],
                                            doc['rating'],
                                            doc['price'],
                                            doc['totalRating'],
                                            doc['description'],
                                          );
                                          setState(() {
                                            services.add(model);
                                          });
                                        });
                                      });
                                      await showSearch<String>(
                                      context: context,
                                      delegate: ServiceSearch(services),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.63,
                                      height: 50,
                                      margin: EdgeInsets.only(right: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(40)
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
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender()));
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width*0.15,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.asset('assets/images/sort.png',width: 25,height: 25,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset('assets/images/filter.png',width: 25,height: 25,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 180,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('banner').snapshots(),
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
                                        child:Text("No Banners")

                                    );

                                  }
                                  return new ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                      return Container(
                                        height: 180,
                                        width: MediaQuery.of(context).size.width*0.85,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: data['image'],
                                            height: 180,
                                            width: MediaQuery.of(context).size.width*0.85,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            )


                          ],
                        ),
                      )
                  )

                ],
              ),
            ),

            Expanded(
              child: ListView(
                children:[
                Container(
                  height: 80,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset("assets/images/wrong.png",width: 50,height:50,),
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
                              Image.asset("assets/images/empty.png",width: 50,height:50,),
                              Text("No categories found")

                            ],
                          ),
                        );

                      }

                      return new ListView(

                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                          return  Container(
                            child:  InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(document.reference.id,data['name'])));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ]
                                ),
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: data['image'],
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                      Text(data['name'], style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
                              Text("No Categories Found")

                            ],
                          ),
                        );

                      }

                      return new ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          CategoryModel model= CategoryModel.fromMap(data, document.reference.id);
                          return new Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data['name'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                      InkWell(
                                        onTap: (){
                                           Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(model.id,model.name)));
                                        },
                                        child: Text("View All",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  height: 120,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('services').where('categoryId', isEqualTo: document.reference.id).snapshots(),
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
                                          child:Text("No Services")

                                        );

                                      }
                                      return new ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                          ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                                          return new Padding(
                                            padding: const EdgeInsets.only(top: 15.0),
                                            child: InkWell(
                                              onTap: (){
                                                Navigator.push(context, new MaterialPageRoute(
                                                    builder: (context) => ServiceDetail(model)));
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


                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 50,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Text("Ad Banner Here"),
                                )
                              ],
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

            SizedBox(
              height: 10,
            ),


          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_beauty/auth/auth_selection.dart';
import 'package:spa_beauty/auth/register.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  List<String> id=[];
  List<ServiceModel> services=[];
  bool isLoaded=false;
  String? language;
  void checkLanguage(){
    String languageCode=context.locale.toLanguageTag().toString();
    languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
    if(languageCode=="US")
      language="English";
    else
      language="Arabic";
    print("language $language $languageCode");
  }
  @override
  Widget build(BuildContext context) {
    checkLanguage();
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
          child: FirebaseAuth.instance.currentUser!=null?Column(
            children: [
              CustomAppBar(_openDrawer, 'favourite'.tr()),
              SizedBox(height: 10,),
              isLoaded?services.length>0?Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (BuildContext context,index){
                    return InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                          ),

                          margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(services[index].image),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                )
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(language=="English"?services[index].name:services[index].name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                      subtitle:Text('service'.tr(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(services[index],false,"")));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15,right: 10,bottom: 10),
                                            width: MediaQuery.of(context).size.width*0.3,
                                            padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: darkBrown
                                            ),
                                            alignment: Alignment.center,
                                            child: Text('bookNow'.tr(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 15,),
                                            Text(services[index].totalRating.toString()),
                                            Container(height: 10, child: VerticalDivider(color: Colors.grey)),
                                            RatingBar(
                                              initialRating: services[index].rating.toDouble(),
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              ratingWidget: RatingWidget(
                                                full: Icon(Icons.star,color: darkBrown),
                                                half: Icon(Icons.star_half,color: darkBrown),
                                                empty:Icon(Icons.star_border,color: darkBrown,),
                                              ),
                                              ignoreGestures: true,
                                              itemSize: 18,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            SizedBox(width: 10,)
                                          ],
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10,)
                                  ],
                                ),
                              )

                            ],
                          )
                      ),
                    );
                  },
                ),
              ):Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text('noFavourite'.tr()),
              ):Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            ],
          ):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/json/nouser.json',width: 150,height: 150),
              Container(
                alignment: Alignment.center,
                child: Text('notLoggedIn'.tr(),style: TextStyle(fontSize: 20),),
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
                  child:Text('login'.tr(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Register()));
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
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('favourites').doc(FirebaseAuth.instance.currentUser!.uid).collection("services").get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          setState(() {
            id.add(doc['serviceId']);
          });
        });
      });
      FirebaseFirestore.instance.collection('services').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          ServiceModel model= ServiceModel.fromMap(data, doc.reference.id);
          for(int i=0;i<id.length;i++){
            if(id[i]==model.id){
              setState(() {
                services.add(model);
              });

            }
          }
        });
        setState(() {
          isLoaded=true;
        });
      });
    }
    

    
    
  }
}

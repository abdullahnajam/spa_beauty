import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/model/portrait_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/select_gender.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/search/search_service.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_beauty/values/sharedPref.dart';
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
  void routing(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));

  }
  bool isFilterTabOpened=false;
  int? rating=5;
  var reviewController=TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('appointments')
        .where("status",isEqualTo: "Completed")
        .where("isRated",isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        AppointmentModel model=AppointmentModel.fromMap(data, doc.reference.id);
        _showRatingDialog(model);
      });
    });
  }
  Future<void> _showRatingDialog(AppointmentModel model) async {
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
            padding: EdgeInsets.only(left: 10,right: 10),
            height: MediaQuery.of(context).size.height*0.53,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('giveRating'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.w500),),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(language=="English"?"${'howWas'.tr()}${'service'.tr()}?":"${'howWas'.tr()}${'service'.tr()}?",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                ),
                SizedBox(height: 10,),
                RatingBar(
                  initialRating: 5,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star,color: darkBrown),
                    half: Icon(Icons.star_half,color: darkBrown),
                    empty:Icon(Icons.star_border,color: darkBrown,),
                  ),
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  onRatingUpdate: (rate) {
                    print(rate);
                    rating=rate.toInt();
                    print("rating $rating");
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  minLines: 3,
                  maxLines: 3,
                  controller: reviewController,
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
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0.5
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'enterReview'.tr(),
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: darkBrown,
                      onPressed: (){
                        print("presed $rating");
                        final ProgressDialog pr = ProgressDialog(context: context);
                        pr.show(max: 100, msg: "Loading");
                        FirebaseFirestore.instance.collection('reviews').doc(model.id).set({
                          'username': model.name,
                          'service': model.serviceName,
                          'serviceId': model.serviceId,
                          'appointmentId':model.id,
                          'status':"Pending",
                          'rating':rating,
                          'review':reviewController.text,
                          'userId':FirebaseAuth.instance.currentUser!.uid,
                        }).then((value) {
                          pr.close();
                          print("added");
                          FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                            'isRated': true,
                            'rating':rating,
                          }).onError((error, stackTrace){
                            final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                          FirebaseFirestore.instance
                              .collection('services')
                              .doc(model.serviceId)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                              ServiceModel model=ServiceModel.fromMap(data, documentSnapshot.reference.id);
                              int totalRating=model.rating;
                              totalRating=rating!+totalRating;
                              int totalUsersRated=model.totalRating++;
                              totalRating=(totalRating/2).toInt();
                              FirebaseFirestore.instance.collection('services').doc(model.id).update({
                                'totalRating': totalUsersRated,
                                'rating':totalRating,
                              }).onError((error, stackTrace){
                                final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
                            }
                          }).onError((error, stackTrace){
                            final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                          Navigator.pop(context);
                        }).onError((error, stackTrace){
                          final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: Text('Review'.tr(),style: TextStyle(color: Colors.white),),
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
  SharedPref sharedPref=new SharedPref();
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
  void changeBannerHeight(var height){
    setState(() {
      height=100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: FutureBuilder<String>(
        future: sharedPref.getGenderPref(),
        builder: (context,prefshot){
          if (prefshot.hasData) {
            if (prefshot.data != null) {
              print("shared ${prefshot.data}");
              checkLanguage();
              return Container(
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
                child: Stack(
                  children: [
                    Column(
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

                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.menu,color: Colors.white,),
                                                onPressed: _openDrawer,
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: ()async{
                                                    List<ServiceModel> services=[];
                                                    FirebaseFirestore.instance.collection('services')
                                                        .where("gender",isEqualTo: prefshot.data)
                                                        .where("isActive",isEqualTo: true)
                                                        .where("isFeatured",isEqualTo: true).get().then((QuerySnapshot querySnapshot) {
                                                      querySnapshot.docs.forEach((doc) {
                                                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                        ServiceModel model=ServiceModel.fromMap(data, doc.reference.id);
                                                        setState(() {
                                                          services.add(model);
                                                        });
                                                      });
                                                      print("size1 ${services.length}");
                                                    }).then((value){
                                                      showSearch<String>(
                                                        context: context,
                                                        delegate: ServiceSearch(services),
                                                      );
                                                    });
                                                    print("size ${services.length}");

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
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender("Home")));
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
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    isFilterTabOpened=true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width*0.15,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: Image.asset('assets/images/filter.png',width: 25,height: 25,),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance.collection('banner')
                                                .where("gender",isEqualTo: prefshot.data.toString())
                                                .where("language",isEqualTo: language).snapshots(),
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
                                                      children: [
                                                        Container(
                                                          height: MediaQuery.of(context).size.height*0.28,
                                                          child: Image.asset("assets/images/logo.png"),
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Text('noBanner'.tr())
                                                      ],
                                                    )

                                                );

                                              }

                                              return new ListView(
                                                scrollDirection: Axis.horizontal,
                                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                                  return Container(
                                                    height: MediaQuery.of(context).size.height*0.32,
                                                    width: MediaQuery.of(context).size.width*0.85,
                                                    margin: EdgeInsets.only(top: 10,left: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: CachedNetworkImage(
                                                        imageUrl: data['image'],
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
                                height: MediaQuery.of(context).size.height*0.15,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('categories')
                                      .where("gender",isEqualTo: prefshot.data.toString())
                                      .where('isFeatured',isEqualTo: true).snapshots(),
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

                                        return  InkWell(
                                          onTap: (){
                                            Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(document.reference.id,data['name'])));
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 80,
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
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
                                                  height: 50,
                                                  width: 50,
                                                  margin: EdgeInsets.all(5),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: CachedNetworkImage(
                                                      imageUrl: data['image'],
                                                      height: 30,
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Text(language=="English"?data['name']:data['name_ar'],textAlign: TextAlign.center, maxLines: 1,style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300
                                                ),)
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('portrait_banner')
                                    .where('type', isEqualTo: 'Category')
                                    .where('gender', isEqualTo: prefshot.data.toString())
                                    .where('language', isEqualTo: language)
                                    .snapshots(),
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

                                    );

                                  }

                                  return new ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                      PortraitModel model= PortraitModel.fromMap(data, document.reference.id);

                                      return new Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) => AllServicesList(model.name,model.linkId)));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            height: MediaQuery.of(context).size.height*0.4,
                                            width: MediaQuery.of(context).size.width*0.9,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(model.image),
                                                  fit: BoxFit.cover
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),

                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('categories')
                                      .where('gender',isEqualTo: prefshot.data.toString())
                                      .where('isFeatured',isEqualTo: true).snapshots(),
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
                                                    Text(language=="English"?data['name']:data['name_ar'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(model.id,model.name)));
                                                      },
                                                      child: Text('viewAll'.tr(),style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Container(
                                                height: 120,
                                                child: StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance.collection('services')
                                                      .where('categoryId', isEqualTo: document.reference.id)
                                                      .where('gender', isEqualTo: prefshot.data.toString())
                                                      .where('isFeatured',isEqualTo: true)
                                                      .where('isActive',isEqualTo: true).snapshots(),
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
                                                        print("service gender : ${model.gender} ${snapshot.data.toString()}");
                                                        return new Padding(
                                                          padding: const EdgeInsets.only(top: 15.0),
                                                          child: InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, new MaterialPageRoute(
                                                                  builder: (context) => ServiceDetail(model,language!)));
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
                                                                      Text(language=="English"?data['name']:data['name_ar'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
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


                                              /*Container(
                                            margin: EdgeInsets.all(10),
                                            height: 50,
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            child: Text("Ad Banner Here"),
                                          )*/
                                            ],
                                          ),

                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('portrait_banner')
                                    .where('type', isEqualTo: 'Service')
                                    .where('gender', isEqualTo: prefshot.data.toString())
                                    .where('language', isEqualTo: language)
                                    .snapshots(),
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

                                    );

                                  }

                                  return new ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                      PortraitModel model= PortraitModel.fromMap(data, document.reference.id);
                                      return new Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: InkWell(
                                          onTap: (){
                                            FirebaseFirestore.instance
                                                .collection('services')
                                                .doc(model.linkId)
                                                .get()
                                                .then((DocumentSnapshot documentSnapshot) {
                                              if (documentSnapshot.exists) {
                                                Map<String, dynamic> serivceData = documentSnapshot.data() as Map<String, dynamic>;
                                                ServiceModel serviceModel= ServiceModel.fromMap(serivceData, document.reference.id);
                                                Navigator.push(context, new MaterialPageRoute(
                                                    builder: (context) => ServiceDetail(serviceModel,language!)));
                                              }
                                            });

                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            height: MediaQuery.of(context).size.height*0.4,
                                            width: MediaQuery.of(context).size.width*0.9,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(model.image),
                                                  fit: BoxFit.cover
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],

                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),


                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        width: MediaQuery.of(context).size.width,
                        height: isFilterTabOpened?MediaQuery.of(context).size.height*0.6:0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                              ),
                            ]
                        ),
                        padding: EdgeInsets.all(10),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text('filter'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          isFilterTabOpened=false;
                                        });
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              );
            }
            else {
              return new Center(
                child: Container(
                    child: Text("no data")
                ),
              );
            }
          }
          else if (prefshot.hasError) {
            return Text('Error : ${prefshot.error}');
          } else {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}

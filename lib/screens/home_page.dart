import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/model/change_model.dart';
import 'package:spa_beauty/model/offer_model.dart';
import 'package:spa_beauty/model/popup_model.dart';
import 'package:spa_beauty/model/portrait_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/model/slider_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/all_categories.dart';
import 'package:spa_beauty/screens/offer_details.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/select_gender.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/screens/survey.dart';
import 'package:spa_beauty/search/search_service.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_beauty/utils/dailog_alerts.dart';
import 'package:spa_beauty/utils/database_services.dart';
import 'package:spa_beauty/utils/sharedPref.dart';
import 'package:spa_beauty/utils/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'all_sub_categories.dart';
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
  Future<void> _showChangeAlertDialog(ChangeModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(model.message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text('ok'.tr()),
              onPressed: () {
                FirebaseFirestore.instance.collection("notification_popup").doc(model.id).update({
                  "isRead":true
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool isFilterTabOpened=false;
  bool isCurrencyLoaded=false;
  final db = DatabaseServices();
  int? rating=5;
  String? align;
  String? symbol;
  String genderImageUrl="";

  Future<List<SliderModel>> getBanners(gender) async{
    int i=0;
    List<SliderModel> slider=[];
    await FirebaseFirestore.instance.collection('banner')
        .where("gender",isEqualTo: gender)
        .where("language",isEqualTo: language)
        .orderBy("position").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        slider.add(SliderModel.fromMap(data, doc.reference.id));
      });
      print("places foreach ${slider.length}");

    });
    print("places retrun ${slider.length}");
    return slider;

  }
  Future<List<PopupModel>> getPopupAds(gender) async{
    int i=0;
    List<PopupModel> popup=[];
    await FirebaseFirestore.instance.collection('popups')
        .where("gender",isEqualTo: gender)
        .where("language",isEqualTo: language).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        int year= int.parse("${data['endDate'][6]}${data['endDate'][7]}${data['endDate'][8]}${data['endDate'][9]}");
        int day= int.parse("${data['endDate'][0]}${data['endDate'][1]}");
        int month= int.parse("${data['endDate'][3]}${data['endDate'][4]}");
        final date = DateTime(year,month,day);
        final difference = date.difference(DateTime.now()).inDays;
        if(difference>0)
          popup.add(PopupModel.fromMap(data, doc.reference.id));
      });
      print("places foreach ${popup.length}");

    });
    print("places retrun ${popup.length}");
    return popup;

  }


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var reviewController=TextEditingController();
  void notificationSetting()async{
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  @override
  void initState() {
    super.initState();
    notificationSetting();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
      }
    });
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance
          .collection('notification_popup')
          .where("userId",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("isRead", isEqualTo:false)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          ChangeModel model=ChangeModel.fromMap(data, doc.reference.id);
          _showChangeAlertDialog(model);

        });
      });
    }

    sharedPref.getGenderPref().then((value){
      print("gender pref : $value");
      sharedPref.getPopupPref().then((popPref){
        print("pop pref : $popPref");
        if(popPref){
          WidgetsBinding.instance!.addPostFrameCallback((_) async{
          List<int> diff=[];
          int expirePopups=0;
            await FirebaseFirestore.instance.collection('popups')
                .where("gender",isEqualTo: value.toString())
                .where("language",isEqualTo: language)
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                int year= int.parse("${doc['endDate'][6]}${doc['endDate'][7]}${doc['endDate'][8]}${doc['endDate'][9]}");
                int day= int.parse("${doc['endDate'][0]}${doc['endDate'][1]}");
                int month= int.parse("${doc['endDate'][3]}${doc['endDate'][4]}");
                diff.add(DateTime(year,month,day).difference(DateTime.now()).inDays);
                print("diff inside ${diff.length}");
                if(DateTime(year,month,day).difference(DateTime.now()).inDays>0){
                  setState(() {
                    expirePopups++;
                  });
                }
              });
            });
            int j=0,n=0;
          print("diff outside ${diff.length}");
          print("expirePopups ${expirePopups}");
            for(int i=0;i<diff.length;i++){
              if(diff[i]>0){
                j++;
              }
              else
                n++;
            }
            print("greater : $j , lesser : $n");
            if(j>0){

            }
            if(expirePopups>0){
              showPopups(value.toString());
              sharedPref.setPopupPref(false);
            }


          });
        }
      });

    });

    sharedPref.getGenderImagePref().then((value){
      print("gender image $value");
      setState(() {
        genderImageUrl=value.toString();
      });
    });

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
    FirebaseFirestore.instance
        .collection('settings')
        .doc('currency')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          isCurrencyLoaded=true;
          symbol=data['symbol'];
          align=data['align'];
        });

      }
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
                      onPressed: ()async{
                        print("pressed $rating");
                        final ProgressDialog pr = ProgressDialog(context: context);
                        pr.show(max: 100, msg: "Loading");
                        await FirebaseFirestore.instance.collection('reviews').add({
                          'username': model.name,
                          'service': model.serviceName,
                          'serviceId': model.serviceId,
                          'appointmentId':model.id,
                          'status':"Pending",
                          'rating':rating,
                          'review':reviewController.text,
                          'datePosted':DateTime.now().millisecondsSinceEpoch,
                          'userId':FirebaseAuth.instance.currentUser!.uid,
                        }).then((value) {
                          pr.close();
                          print("added");
                          FirebaseFirestore.instance.collection('appointments').doc(model.id).update({
                            'isRated': true,
                            'rating':rating,
                          }).onError((error, stackTrace){
                            pr.close();
                            print("Database 1 Error : ${error.toString()}");
                            final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                        }).onError((error, stackTrace){
                          pr.close();
                          print("Database 2 Error : ${error.toString()}");
                          final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                        await FirebaseFirestore.instance.collection('settings').doc('points').get().then((DocumentSnapshot pointSnapshot) {
                          if (pointSnapshot.exists) {

                            print("point exists");
                            Map<String, dynamic> point = pointSnapshot.data() as Map<String, dynamic>;
                            print("mypoint ${point['point']}");
                            int reviewPoints=int.parse(point['point']);
                            FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot userSnap) {
                              if (userSnap.exists) {
                                Map<String, dynamic> user = userSnap.data() as Map<String, dynamic>;
                                print("customer ${user['points']}");
                                int userPoints=user['points'];
                                print("user points $userPoints");
                                int points=userPoints+reviewPoints;
                                print("points $points ${user['points']} ${point['point']}");
                                FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                  'points': points,
                                }).onError((error, stackTrace){
                                  pr.close();
                                  print("Database 3 Error : ${error.toString()}");
                                  final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                });
                              }
                            }).onError((error, stackTrace){
                              pr.close();
                              print("Database 4 Error : ${error.toString()}");
                              final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            });

                          }
                        }).onError((error, stackTrace){
                          pr.close();
                          print("Database 5 Error : ${error.toString()}");
                          final snackBar = SnackBar(content: Text("Database Error : ${error.toString()}"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                        Navigator.pop(context);
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => Survey(model.name)));
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
    print("languge code ${context.locale.languageCode}");
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

  void showPopups(String gender){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context,setState){
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
                    height: MediaQuery.of(context).size.height*0.6,
                    width: MediaQuery.of(context).size.width*0.9,
                  child: Stack(
                    children: [

                     /* Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('popups')
                              .where("gender",isEqualTo: gender)
                              .where("language",isEqualTo: language)
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                    Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                               Navigator.pop(context);
                            }

                            return new ListView(
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                int year= int.parse("${data['endDate'][6]}${data['endDate'][7]}${data['endDate'][8]}${data['endDate'][9]}");
                                int day= int.parse("${data['endDate'][0]}${data['endDate'][1]}");
                                int month= int.parse("${data['endDate'][3]}${data['endDate'][4]}");
                                final date = DateTime(year,month,day);
                                final difference = date.difference(DateTime.now()).inDays;
                                print("${DateTime.now()} - $date = $difference");
                                return new Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: difference>0?InkWell(
                                    onTap: ()async{
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(data['link'].toString())));
                                     // await launch();
                                      //await canLaunch(data['link']) ?  : throw 'Could not launch ${data['link']}';
                                    },
                                    child: Image.network(
                                      data['image'],
                                      height: MediaQuery.of(context).size.height*0.35,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    )
                                  ):Container(),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),*/
                      FutureBuilder<List<PopupModel>>(
                        future: getPopupAds(gender),
                        builder: (context,snapshot){
                          if (snapshot.hasData) {
                            if (snapshot.data != null && snapshot.data!.length>0) {
                              return CarouselSlider.builder(

                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height*0.6,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    aspectRatio: 1,
                                    initialPage: 0,
                                  ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                      InkWell(
                                        onTap: ()async{
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebViewScreen(snapshot.data![itemIndex].link)));
                                          // await launch();
                                          //await canLaunch(data['link']) ?  : throw 'Could not launch ${data['link']}';
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*0.6,
                                          width: MediaQuery.of(context).size.width*0.9,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage( snapshot.data![itemIndex].image),
                                                  fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),

                                        ),
                                      )
                              );
                            }
                            else {
                              return Container(
                                  alignment: Alignment.center,
                                  child:Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.27,
                                        child: Image.asset("assets/images/logo.png"),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('noBanner'.tr())
                                    ],
                                  )

                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return Text('Error : ${snapshot.error}',style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .apply(color: Colors.black),);
                          } else {
                            return new Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.close),
                              ),
                            ),
                          )
                      )
                    ],
                  )
                ),
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _drawerKey,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          final ProgressDialog pr = ProgressDialog(context: context);
          pr.show(max: 100, msg: "Loading");
          SharedPref sharedPref=new SharedPref();
          sharedPref.getGenderPref().then((value){
            FirebaseFirestore.instance.collection('settings').doc("whatsapp").collection("contacts")
                .where("gender", isEqualTo:value.toString()).get().then((QuerySnapshot querySnapshot) {querySnapshot.docs.forEach((doc) {
              pr.close();
              FlutterOpenWhatsapp.sendSingleMessage(doc['contact'], "Book a service from Hammam spa & beauty app");

            });
            });

            pr.close();
          });



        },
        child: Image.asset("assets/images/whatsapp.png"),
        backgroundColor: Colors.green,
      ),
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
                child: isCurrencyLoaded?Column(
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
                                      padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
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
                                                    delegate: ServiceSearch(services,language),
                                                  );
                                                });
                                                print("size ${services.length}");

                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width*0.63,
                                                height: 50,
                                                margin: EdgeInsets.only(right: 5,left: 5),
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
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(genderImageUrl),
                                                      fit: BoxFit.cover
                                                  ),
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
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height*0.3,
                                      child: FutureBuilder<List<SliderModel>>(
                                        future: getBanners(prefshot.data.toString()),
                                        builder: (context,snapshot){
                                          if (snapshot.hasData) {
                                            if (snapshot.data != null && snapshot.data!.length>0) {
                                              return CarouselSlider.builder(

                                                  options: CarouselOptions(
                                                    autoPlay: true,
                                                    height: MediaQuery.of(context).size.height*0.32,
                                                    enlargeCenterPage: true,
                                                    viewportFraction: 1,
                                                    aspectRatio: 1,
                                                    initialPage: 0,
                                                  ),
                                                  itemCount: snapshot.data!.length,
                                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                                      Container(
                                                        height: MediaQuery.of(context).size.height*0.32,
                                                        width: MediaQuery.of(context).size.width*0.9,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage( snapshot.data![itemIndex].image),
                                                                fit: BoxFit.cover
                                                            ),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        /* child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(20),
                                                              child: CachedNetworkImage(
                                                                imageUrl: snapshot.data![itemIndex].image,
                                                                height: MediaQuery.of(context).size.height*0.12,
                                                                width: MediaQuery.of(context).size.width*0.9,
                                                                fit: BoxFit.fitHeight,
                                                                placeholder: (context, url) => Center(
                                                                  child: CircularProgressIndicator(),
                                                                ),
                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                              ),
                                                            ),*/
                                                      )
                                              );
                                            }
                                            else {
                                              return Container(
                                                  alignment: Alignment.center,
                                                  child:Column(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(context).size.height*0.27,
                                                        child: Image.asset("assets/images/logo.png"),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text('noBanner'.tr())
                                                    ],
                                                  )

                                              );
                                            }
                                          }
                                          else if (snapshot.hasError) {
                                            return Text('Error : ${snapshot.error}',style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .apply(color: Colors.black),);
                                          } else {
                                            return new Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),


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
                            margin: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('categories'.tr(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, new MaterialPageRoute(builder: (context) => AllCategories()));
                                  },
                                  child: Text('viewAll'.tr(),style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.15,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('categories')
                                  .where("gender",isEqualTo: prefshot.data.toString())
                                  .where('isFeatured',isEqualTo: true)
                                  .orderBy("position").snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Column(
                                      children: [
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
                                    CategoryModel model=CategoryModel.fromMap(data, document.reference.id);

                                    return  InkWell(
                                      onTap: ()async{
                                        int i=0;
                                        await FirebaseFirestore.instance.collection('categories')
                                            .where("mainCategoryId", isEqualTo: model.id).get().then((QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            i++;
                                          });
                                        });
                                        if(i>0){
                                          Navigator.push(context, new MaterialPageRoute(builder: (context) => AllSubCategories(model)));

                                        }
                                        else
                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(document.reference.id,language=="English"?data['name']:data['name_ar'])));
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
                                                  image: DecorationImage(
                                                    image: NetworkImage(data['image']),
                                                    fit: BoxFit.cover
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 5.0,
                                                      spreadRadius: 2.0,
                                                    ),
                                                  ]
                                              ),
                                              height: 65,
                                              width: 65,
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
                                .orderBy("position")
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
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  PortraitModel model= PortraitModel.fromMap(data, document.reference.id);

                                  return new Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) => AllServicesList(model.linkId,language=="English"?model.name:model.name)));
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
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('portrait_banner')
                                .where('type', isEqualTo: 'Offer')
                                .where('gender', isEqualTo: prefshot.data.toString())
                                .where('language', isEqualTo: language)
                                .orderBy("position")
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
                                  Map<String, dynamic> portraitData = document.data() as Map<String, dynamic>;

                                  PortraitModel portrait= PortraitModel.fromMap(portraitData, document.reference.id);
                                  return new Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: InkWell(
                                      onTap: (){
                                        FirebaseFirestore.instance.collection('offers').doc(portrait.linkId).get().then((DocumentSnapshot documentSnapshot) {
                                          if (documentSnapshot.exists) {
                                            Map<String, dynamic> offerData = documentSnapshot.data() as Map<String, dynamic>;
                                            OfferModel offerModel= OfferModel.fromMap(offerData, document.reference.id);
                                            ServiceModel model2=new ServiceModel(
                                                offerModel.id,
                                                offerModel.name,
                                                "",
                                                "",
                                                "",
                                                false,
                                                "",
                                                "offer",
                                                "",
                                                "",
                                                0,
                                                offerModel.discount,
                                                0,
                                                "",
                                                true,
                                                0,
                                                "",
                                                false,
                                                0,
                                                false
                                            );
                                            Navigator.push(context, new MaterialPageRoute(builder: (context) => OfferDetail(model2,offerModel)));
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
                                              image: NetworkImage(portrait.image),
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
                          Container(
                            height: 120,
                            child: symbol==""?Center(
                              child: CircularProgressIndicator(),
                            ):StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('services')
                                  .where('gender', isEqualTo: prefshot.data.toString())
                                  .where('isFeatured',isEqualTo: true)
                                  .where('isActive',isEqualTo: true)
                                  .orderBy("position").snapshots(),
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
                                  return Container();

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
                                                  if(align=="Left")
                                                    Text("$symbol${data['price']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)
                                                  else
                                                    Text("${data['price']}$symbol",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                                  Row(
                                                    children: [
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

                                                      Text("( ${data['totalRating']} )",style: TextStyle(fontSize: 10,color: darkBrown),)
                                                    ],
                                                  )
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
                          if(context.locale.languageCode=="en")
                            Container(
                              margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          )
                          else
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.arrow_back),
                                ],
                              ),
                            ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('portrait_banner')
                                .where('type', isEqualTo: 'Service')
                                .where('gender', isEqualTo: prefshot.data.toString())
                                .where('language', isEqualTo: language)
                                .orderBy("position")
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
                                  Map<String, dynamic> portraitData = document.data() as Map<String, dynamic>;

                                  PortraitModel portrait= PortraitModel.fromMap(portraitData, document.reference.id);
                                  return new Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: InkWell(
                                      onTap: (){
                                        FirebaseFirestore.instance.collection('services').doc(portrait.linkId).get().then((DocumentSnapshot documentSnapshot) {
                                          if (documentSnapshot.exists) {
                                            Map<String, dynamic> serivceData = documentSnapshot.data() as Map<String, dynamic>;
                                            ServiceModel serviceModel= ServiceModel.fromMap(serivceData, document.reference.id);
                                            Navigator.push(context, new MaterialPageRoute(builder: (context) => ServiceDetail(serviceModel,language!)));
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
                                              image: NetworkImage(portrait.image),
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
                ):Container(),
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

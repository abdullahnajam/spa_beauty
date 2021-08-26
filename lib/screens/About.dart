import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:spa_beauty/model/about_model.dart';
import 'package:spa_beauty/model/specialist_model.dart';
import 'package:spa_beauty/screens/home_page.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  var userId ;
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
    final orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    checkLanguage();
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
                    imageUrl: "https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/images%2F2021-07-27%2001%3A32%3A26.028.png?alt=media&token=fd4da843-d989-4ecc-9e9e-c449be162a8a",
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
                    icon: Icon(Icons.share),
                    color: Colors.transparent,
                    onPressed: (){} ,
                  ),
                ),

                Positioned(
                  left: 20,
                  top: 40,
                  child: InkWell(onTap: ()=> Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ),child: Icon(Icons.arrow_back_ios_sharp,color:Colors.black54,size: 25,)),
                )
              ],
            ),

            SizedBox(
              height: size.height*0.02,
            ),

            DefaultTabController(
                length: 4,
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
                        labelStyle: TextStyle(fontSize: 10),
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
                          Tab(text: 'description'.tr(),),
                          Tab(text: 'Gallery'.tr()),
                          Tab(text: 'specialist'.tr()),
                          Tab(text: 'location'.tr()),
                        ],
                      ),

                    ),

                    Container(
                      //height of TabBarView
                      height: MediaQuery.of(context).size.height*0.465,

                      child: TabBarView(children: <Widget>[



                        // description
                         Container(
                                height: 100,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('about').snapshots(),
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
                                          child:Text("No Data")

                                      );

                                    }
                                    return new ListView(
                                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        AboutModel model= AboutModel.fromMap(data, document.reference.id);
                                        userId = model.id;
                                        return   Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('workingTime'.tr(),style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(model.time,style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300
                                              ),
                                              ),
                                              SizedBox(height: 10,),
                                              Text('description'.tr(),style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(language=="English"?model.description:model.description_ar,maxLines: 5,style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300
                                              ),
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row (
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Column(
                                                    children: [
                                                      Text('contactInfo'.tr(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                                      SizedBox(height: 5,),
                                                      Text(model.contact,style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),),
                                                    ],
                                                  ),


                                                  IconButton(icon: Icon(Icons.call),color: Colors.green, onPressed: (){
                                                    _service('tel:'+model.contact);
                                                  })

                                                ],
                                              ),




                                              SizedBox(height: 10,),

                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),

                        // gallery
                         Container(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('gallery').where("serviceId",isEqualTo: "about" ).snapshots(),
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
                                  //AboutModel model= AboutModel.fromMap(data, document.reference.id);1
                                  print(userId);
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
                            stream: FirebaseFirestore.instance.collection('specialists').snapshots(),
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
                                    child:Text('noSpecialist'.tr())

                                );

                              }
                              return new GridView(

                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  SpecialistModel model=SpecialistModel.fromMap(data, document.reference.id);
                                  print(userId);
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(),
                                        image: DecorationImage(
                                            image: NetworkImage(model.image),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.all(10),
                                      child: Text(language=="English"?model.name:model.name_ar,style: TextStyle(color: Colors.white),),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                         Container(
                           child: Column(

                             children: [
                               SizedBox(
                                 height: size.height*0.005,
                               ),

                               Text("Branches",style:TextStyle(
                                 fontSize: 16,
                                 color: Colors.black54,
                               ) ,),
                               SizedBox(
                                 height: 10,
                               ),


                               Container(
                                 height: size.height*0.4,
                                 child: StreamBuilder<QuerySnapshot>(
                                   stream: FirebaseFirestore.instance.collection('branches').snapshots(),
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
                                           child:Text("No Data")

                                       );

                                     }
                                     return new ListView(
                                       scrollDirection: Axis.vertical,
                                       children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                        // AboutModel model= AboutModel.fromMap(data, document.reference.id);
                                         //userId = model.id;
                                         return  Container(
                                             alignment: Alignment.centerLeft,
                                             margin: EdgeInsets.all(10),
                                             child: Column(
                                               children: [
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Branch Name",style: TextStyle(
                                                             fontSize: 18,
                                                             color: Colors.black54,
                                                             fontWeight: FontWeight.w500
                                                         ),
                                                         ),
                                                         SizedBox(height: 3,),
                                                         Text(data['name'],style: TextStyle(
                                                             fontSize: 15,
                                                             color: Colors.black54,
                                                             fontWeight: FontWeight.w300
                                                         ),
                                                         ),
                                                         SizedBox(height: 5,),
                                                         Text(data['phone'],style: TextStyle(
                                                             fontSize: 15,
                                                             color: Colors.black54,
                                                             fontWeight: FontWeight.w300
                                                         ),
                                                         ),
                                                       ],
                                                     ),

                                                     InkWell(
                                                       onTap: ()=>MapsLauncher.launchQuery(
                                                           data['location']),
                                                       child: Container(
                                                         height: size.height*0.04,
                                                         padding: EdgeInsets.only(left: 10,right: 10),
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(10),
                                                           color: lightBrown,
                                                         ),
                                                         child: Center(child: Text("Get Direction",style: TextStyle(
                                                           color: Colors.white,
                                                           fontWeight: FontWeight.bold,
                                                         ),)),
                                                       ),
                                                     ),

                                                   ],
                                                 ),
                                                 Divider(
                                                   endIndent: 5,
                                                   indent: 5,
                                                   height: 30,
                                                   //thickness: 1,
                                                   color: Colors.black54,
                                                 ),

                                               ],
                                             )
                                         )  ;
                                       }).toList(),
                                     );
                                   },
                                 ),
                               ),



                             ],
                           ),
                         ),

                      ]),
                    ),



                  ],

                )
            ),



          ],
        ),
      ),



    );
  }
  _service(String url) async {
    try{

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    catch (e)
    {
      print("error");
    }
  }

}

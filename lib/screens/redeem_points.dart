import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/point_service_reservation.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class RedeemPoints extends StatefulWidget {
  const RedeemPoints({Key? key}) : super(key: key);

  @override
  _RedeemPointsState createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
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
  int myPoints=0;
  bool isPointsLoaded=false;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          myPoints=data['points'];
          isPointsLoaded=true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    checkLanguage();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
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
          child: isPointsLoaded?Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.15, color: darkBrown),
                  ),
                ),
                height:  AppBar().preferredSize.height,
                child: Stack(
                  children: [

                    Align(
                      alignment: Alignment.center,
                      child: Text('redeemPoints'.tr()),
                    ),
                    context.locale.languageCode=="en"?
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ):
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('myPoints'.tr(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text(myPoints.toString(),style: TextStyle(fontSize: 18,color: darkBrown),),

                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('services')
                      .where("isRedeemable", isEqualTo: true).snapshots(),
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
                      return Center(
                          child: Text('noServices'.tr(),style: TextStyle(color: Colors.black))
                      );

                    }

                    return new GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        ServiceModel model=ServiceModel.fromMap(data,document.reference.id);
                        return InkWell(
                          onTap: (){
                            if(myPoints>=model.redeemPoints){
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => PointServiceReservation(myPoints, model)));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),


                            margin: const EdgeInsets.all( 10),
                            child: Column(
                              children: [
                                if(myPoints>=model.redeemPoints)
                                  Container(
                                      height: MediaQuery.of(context).size.height*0.16,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(model.image),
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 20,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: lightBrown,
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.local_offer,color: Colors.white,size: 15,),
                                                SizedBox(width: 5,),
                                                Text(model.redeemPoints.toString(),style: TextStyle(fontSize: 10,color: Colors.white),),
                                              ],
                                            ),
                                          )
                                      )
                                  )
                                else
                                  Container(
                                  height: MediaQuery.of(context).size.height*0.16,
                                      decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  ),
                                          image: DecorationImage(
                                            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                                            image: NetworkImage(model.image),
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 20,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: lightBrown,
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.local_offer,color: Colors.white,size: 15,),
                                                SizedBox(width: 5,),
                                                Text(model.redeemPoints.toString(),style: TextStyle(fontSize: 10,color: Colors.white),),
                                              ],
                                            ),
                                          )
                                      )
                                  ),
                                if(myPoints>=model.redeemPoints)
                                Container(
                                  alignment: Alignment.center,
                                  child:Text(language=="English"?model.name:model.name_ar,textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                                )
                                else
                                  Container(
                                    alignment: Alignment.center,
                                    child:Text(language=="English"?model.name:model.name_ar,textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey),),
                                  )


                              ],
                            )
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ],
          ):Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/appointments.dart';
import 'package:spa_beauty/screens/my_account.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class AppointmentTile extends StatefulWidget {
  AppointmentModel model;

  AppointmentTile(this.model);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  int? rating=5;
  var reviewController=TextEditingController();
  String? language;
  void checkLanguage(){
    String languageCode=context.locale.toLanguageTag().toString();
    languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
    if(languageCode=="US"){
      language="English";
    }
    else {
      if(widget.model.status=="Pending")
        setState(() {
          widget.model.status="قيد الانتظار";
        });
      else if(widget.model.status=="Approved")
        setState(() {
          widget.model.status="وافق";
        });
      else if(widget.model.status=="Completed")
        setState(() {
          widget.model.status="مكتمل";
        });
      else if(widget.model.status=="Cancelled")
        setState(() {
          widget.model.status="ألغيت";
        });
      if(widget.model.paymentMethod=="Points Redemption")
        setState(() {
          widget.model.paymentMethod="استبدال النقاط";
        });
      else if(widget.model.paymentMethod=="Cash Payment")
        setState(() {
          widget.model.paymentMethod="دفع نقدا";
        });
      else if(widget.model.paymentMethod=="Card Payment")
        setState(() {
          widget.model.paymentMethod="بطاقه ائتمان";
        });

      language = "Arabic";
      FirebaseFirestore.instance.collection("services").doc(widget.model.serviceId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            widget.model.serviceName=data['name_ar'];
          });

        }
      });
    }
    print("language $language $languageCode");
  }
  Future<void> _showRatingDialog() async {
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
            height: MediaQuery.of(context).size.height*0.43,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("GIVE RATING",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.w400),),
                ),
                SizedBox(height: 20,),
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
                    hintText: "Enter Review",
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
                        FirebaseFirestore.instance.collection('reviews').doc(widget.model.id).set({
                          'username': widget.model.name,
                          'service': widget.model.serviceName,
                          'serviceId': widget.model.serviceId,
                          'appointmentId':widget.model.id,
                          'status':"Pending",
                          'rating':rating,
                          'review':reviewController.text,
                          'userId':FirebaseAuth.instance.currentUser!.uid,
                        }).then((value) {
                          pr.close();
                          print("added");
                          FirebaseFirestore.instance.collection('appointments').doc(widget.model.id).update({
                            'isRated': true,
                            'rating':rating,
                          });
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Update",style: TextStyle(color: Colors.white),),
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


  String? symbol,align;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('settings')
        .doc('currency')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          symbol=data['symbol'];
          align=data['align'];
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkLanguage();
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child:   InkWell(
        onTap: (){
          if (widget.model.isRated == false && widget.model.status == 'Completed') {
              _showRatingDialog();
          }
          if(widget.model.status == 'Pending' || widget.model.status=="قيد الانتظار" ||
              widget.model.status == 'Approved' || widget.model.status=="وافق"){
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('cancelBooking'.tr()),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children:  <Widget>[
                        Text('cancelConfirm'.tr()),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child:  Text('ok'.tr()),
                      onPressed: () {
                        FirebaseFirestore.instance.collection("cancelled").doc(widget.model.id).set({
                          'user':widget.model.name,
                          'userId':FirebaseAuth.instance.currentUser!.uid,
                          'service': widget.model.serviceName,
                          'dateTime': "${widget.model.time}, ${widget.model.date}"
                        }).then((value) {
                          final snackBar = SnackBar(content: Text("Request submitted. Please wait for admin approval"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop();
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Appointments()));
                        });

                      },
                    ),
                  ],
                );
              },
            );

          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            //border: Border.all(color:Colors.black54),
          ),

          margin: EdgeInsets.all(5),
          child: widget.model.status == 'Completed' || widget.model.status == 'Cancelled' ||
              widget.model.status == 'مكتمل' || widget.model.status == 'ألغيت'?
              Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height*0.01,),
                              Text(widget.model.serviceName,style: TextStyle(
                                color: Colors.black87,
                                //fontFamily: 'Georgia Regular',
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),),
                              SizedBox(height: size.height*0.0055,),
                              Row(
                                children: [
                                  symbol==""?Container():

                                  align=="Left"?
                                  Text("$symbol${widget.model.amount}",style: TextStyle(
                                    color: Colors.black87,
                                    //fontFamily: 'Georgia Regular',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),):
                                  Text("${widget.model.amount}$symbol",style: TextStyle(
                                    color: Colors.black87,
                                    //fontFamily: 'Georgia Regular',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),),
                                  SizedBox(width: 10,),
                                  Text(widget.model.paymentMethod,style: TextStyle(
                                    color: Colors.black87,
                                    //fontFamily: 'Georgia Regular',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),),
                                ],
                              ),
                              SizedBox(height: size.height*0.0055,),
                              Text("${widget.model.date}   ${widget.model.time}",style: TextStyle(
                                color: Colors.black87,
                                //fontFamily: 'Georgia Regular',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),),
                              SizedBox(height: size.height*0.0055,),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child: VerticalDivider(
                            thickness: 0.3,
                            width: 2,
                            color: Colors.black,
                          ),
                        ),

                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0,8, 0, 0),

                                //width: MediaQuery.of(context).size.width*0.2,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: darkBrown
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(widget.model.status,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              SizedBox(height: size.height*0.005,),
                              widget.model.status == 'Completed' || widget.model.status == 'مكتمل'?
                              widget.model.isRated ? RatingBar(
                                initialRating: widget.model.rating.toDouble(),
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
                              ) : Container(child: Text("NOT RATED",style: TextStyle(fontSize: 10,color: Colors.grey),) , )
                                  :Container(),

                            ],
                          ),
                        )


                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      String language;
                      String languageCode=context.locale.toLanguageTag().toString();
                      languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
                      if(languageCode=="US")
                        language="English";
                      else
                        language="Arabic";
                      FirebaseFirestore.instance
                          .collection('services')
                          .doc(widget.model.serviceId)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                          ServiceModel service=ServiceModel.fromMap(data, documentSnapshot.reference.id);
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ServiceDetail(service,language)));
                        }
                      });

                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: lightBrown,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                      ),
                      child: Text('bookAgain'.tr(),style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              )
              :IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height*0.01,),
                      Text(widget.model.serviceName,style: TextStyle(
                        color: Colors.black87,
                        //fontFamily: 'Georgia Regular',
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),),
                      SizedBox(height: size.height*0.0055,),
                      Row(
                        children: [
                          symbol==""?Container():

                          align=="Left"?
                          Text("$symbol${widget.model.amount}",style: TextStyle(
                            color: Colors.black87,
                            //fontFamily: 'Georgia Regular',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),):
                          Text("${widget.model.amount}$symbol",style: TextStyle(
                            color: Colors.black87,
                            //fontFamily: 'Georgia Regular',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),),
                          SizedBox(width: 10,),
                          Text(widget.model.paymentMethod,style: TextStyle(
                            color: Colors.black87,
                            //fontFamily: 'Georgia Regular',
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),),
                        ],
                      ),
                      SizedBox(height: size.height*0.0055,),
                      Text("${widget.model.date}   ${widget.model.time}",style: TextStyle(
                        color: Colors.black87,
                        //fontFamily: 'Georgia Regular',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),),
                      SizedBox(height: size.height*0.0055,),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: VerticalDivider(
                    thickness: 0.3,
                    width: 2,
                    color: Colors.black,
                  ),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0,8, 0, 0),

                        //width: MediaQuery.of(context).size.width*0.2,
                        child: Container(
                          height: 25,
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: darkBrown
                          ),
                          alignment: Alignment.center,
                          child: Text(widget.model.status,style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: size.height*0.005,),
                      widget.model.status == 'Completed' ?
                      widget.model.isRated ? RatingBar(
                        initialRating: widget.model.rating.toDouble(),
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
                      ) : Container(child: Text("NOT RATED",style: TextStyle(fontSize: 10,color: Colors.grey),) , )
                          :Container(),

                    ],
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

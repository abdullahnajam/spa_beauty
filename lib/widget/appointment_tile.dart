import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/screens/appointments.dart';
import 'package:spa_beauty/screens/my_account.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/values/constants.dart';

class AppointmentTile extends StatefulWidget {
  AppointmentModel model;

  AppointmentTile(this.model);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  int? rating=5;
  var reviewController=TextEditingController();


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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child:   InkWell(
        onTap: (){
          if (widget.model.isRated == false && widget.model.status == 'Completed')
            {
              _showRatingDialog();
            }
          if(widget.model.status == 'Pending'){
            AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Cancel booking',
              desc: 'Are you sure you want to cancel your appointment?',
              btnCancelOnPress: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Appointments()));
              },


              btnOkOnPress: () {
                FirebaseFirestore.instance.collection("appointments").doc(widget.model.id).update({
                  'status':"Cancelled",
                }).then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Appointments()));
                });

              },
            )..show();
          }
        },
        child: Container(
          height: size.height*0.08,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            //border: Border.all(color:Colors.black54),
          ),

          margin: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                alignment: Alignment.centerLeft,
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
                    Text("${widget.model.date}   ${widget.model.time}",style: TextStyle(
                      color: Colors.black87,
                      //fontFamily: 'Georgia Regular',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),),
                  ],
                ),
              ),

              VerticalDivider(
                indent: 10,
                endIndent: 10,
                thickness: 1.3,
                color: Colors.black54,
              ),


              Column(
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
                  widget.model.status == 'Completed' ? widget.model.isRated ? RatingBar(
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
                  ) : Container(child: Text("NOT RATED",style: TextStyle(fontSize: 10,color: Colors.grey),) , ) :Container(),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

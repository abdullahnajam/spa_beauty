import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/screens/appointments.dart';
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

  Future<void> _showRatedDialog() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            final _formKey = GlobalKey<FormState>();
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
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Give Rating",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6!.apply(color: darkBrown),),
                            ),
                          ),

                        ],
                      ),
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
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        minLines: 3,
                        maxLines: 3,
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
                      InkWell(
                        onTap: (){
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Please wait");
                          FirebaseFirestore.instance.collection('appointments').doc(widget.model.id).update({
                            'isRated':true,
                            'rating':rating!,
                          }).then((value) {
                            pr.close();
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            pr.close();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Error',
                              desc: '${error.toString()}',
                              btnOkOnPress: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Appointments()));
                              },
                            )..show();
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                          child:Text("SUBMIT",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            );
          },
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
              _showRatedDialog();
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
            children: [
              SizedBox(width: size.width*0.05,),

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

              SizedBox(width: size.width*0.1,),
              VerticalDivider(
                indent: 10,
                endIndent: 10,
                thickness: 1.3,
                color: Colors.black54,
              ),

              SizedBox(width: size.width*0.12,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,

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
                  ) : Container(child: Text("Not Rated") , ) :Container(),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

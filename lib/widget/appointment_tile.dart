import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/values/constants.dart';

class AppointmentTile extends StatefulWidget {
  AppointmentModel model;

  AppointmentTile(this.model);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {

  Future<void> _showRatedDialog() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
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
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:Container(),
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

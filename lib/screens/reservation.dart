import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/payment/payment-service.dart';
import 'package:spa_beauty/values/constants.dart';
class Reservation extends StatefulWidget {
  ServiceModel model;


  Reservation(this.model);

  @override
  _ReservationState createState() => _ReservationState();
}


class _ReservationState extends State<Reservation> {

  payViaNewCard(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");

    await StripeService.payWithNewCard(
        amount: '15000',
        currency: 'USD'
    ).whenComplete(() {
      bookAppointment();
    });
    pr.close();

  }
  bookAppointment(){
    final f = new DateFormat('dd-MM-yyyy');
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('appointments').add({
      'name': "model.name",
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'date': f.format(_selectedDate).toString(),
      'time': appointmentTimeSelected,
      'specialistId': specialistId,
      'specialistName': specialistName,
      'serviceId':widget.model.id,
      'serviceName': widget.model.name,
      'status': "pending",
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }
  DateTime _selectedDate=DateTime.now();
  String? appointmentTimeSelected;
  List<String> time=[];
  List<bool> timeSelected=[];
  String specialistName="none";
  String specialistId="none";
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.33,
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
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)
              )
            ),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(12),
                        child:Text("SELECT DATE & TIME",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
                      )
                    )
                  ],
                ),
                SizedBox(height: 10,),
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: lightBrown,
                  selectedTextColor: Colors.white,
                  monthTextStyle: TextStyle(color: Colors.white),
                  dateTextStyle: TextStyle(color: Colors.white),
                  dayTextStyle: TextStyle(color: Colors.white),
                  onDateChange: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 30,),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.33,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10),
                  child: Text("Available Slots",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('gallery').where("serviceId",isEqualTo: widget.model.id).snapshots(),
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
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount: (orientation == Orientation.portrait) ? 4 : 6),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          for(int i=0;i<snapshot.data!.size;i++){
                            time.add(data['time']);
                            timeSelected.add(false);
                          }
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                child: Text("10:00 AM",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: 10,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (itemWidth / itemHeight),
                        crossAxisCount: (orientation == Orientation.portrait) ? 4 : 6),
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            alignment: Alignment.center,
                            child: Text("10:00 AM",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.34,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Choose Specialist",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                ),
                Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context,index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage("assets/images/placeholder.png"),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.all(10),
                          child: Text("Name",style: TextStyle(color: Colors.white),),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: (){
                    payViaNewCard(context);
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
                    child:Text("Book an Appointment",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }
}

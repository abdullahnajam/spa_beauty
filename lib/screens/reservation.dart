import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/model/specialist_model.dart';
import 'package:spa_beauty/model/time_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/payment/payment-service.dart';
import 'package:spa_beauty/screens/checkout.dart';
import 'package:spa_beauty/values/constants.dart';
class Reservation extends StatefulWidget {
  ServiceModel model;
  bool isOffer,isPercentage;
  String discount;


  Reservation(this.model,this.isOffer,this.isPercentage,this.discount);

  @override
  _ReservationState createState() => _ReservationState();
}


class _ReservationState extends State<Reservation> {

  List<TimeModel> time=[];
  String payment='Cash on delivery';
  int? amount;
  var couponController=TextEditingController();
  String? username;
  List<SpecialistModel> specialist=[];
  getSpecialists(){
    FirebaseFirestore.instance.collection('specialists').where("serviceId",isEqualTo: widget.model.id).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        SpecialistModel model=SpecialistModel.fromMap(data,doc.reference.id);
        setState(() {
          specialist.add(model);
        });
      });
      setState(() {
        isSpecialistLoading=false;
      });
    });
  }
  getTimeSlots(){
    FirebaseFirestore.instance.collection('timeslots').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        TimeModel timeModel=new TimeModel(doc['time'], doc['max'],false);
        setState(() {
          time.add(timeModel);
        });
      });
      setState(() {
        isTimeLoading=false;
      });
    });
  }

  bool isTimeLoading=true;
  bool isSpecialistLoading=true;
  final f = new DateFormat('dd-MM-yyyy');

  DateTime _selectedDate=DateTime.now();
  String? appointmentTimeSelected;
  List<bool> timeSelected=[];
  String specialistName="none";
  String specialistId="none";
  Future<void> _showConfirmDialog() async {
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
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
                              child: Text("Confirm",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6!.apply(color: Colors.grey),),
                            ),
                          ),

                        ],
                      ),

                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Text(
                                  "Date & Time",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                Text(
                                  "${f.format(_selectedDate).toString()} $appointmentTimeSelected",
                                  style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                Text(
                                  "$amount",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add Coupon",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller:couponController,
                                  style: TextStyle(color: Colors.black),
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
                                        color: darkBrown,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: darkBrown,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: darkBrown,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                  color: darkBrown,
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: payment,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    payment = newValue!;
                                  });
                                },
                                items: <String>['Cash on delivery', 'Card Payment', 'Pay Later']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),



                            SizedBox(height: 15,),
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                height: 50,
                                color: darkBrown,
                                alignment: Alignment.center,
                                child: Text("Book",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                              ),
                            )
                          ],
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
                isTimeLoading?
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ):Expanded(
                  child: GridView.builder(
                    itemCount: time.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (itemWidth / itemHeight),
                        crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: (){

                            for(int i=0;i<time.length;i++){
                              if(i==index){
                                setState(() {
                                  time[i].isSelected=true;
                                  appointmentTimeSelected=time[i].time;
                                });
                              }
                              else{
                                setState(() {
                                  time[i].isSelected=false;
                                });
                              }

                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: time[index].isSelected?lightBrown:Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            alignment: Alignment.center,
                            child: Text(time[index].time,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),maxLines: 1,),
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
                isSpecialistLoading?
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ):Container(
                  height: 120,
                  child: specialist.length>0?ListView.builder(
                    itemCount: specialist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context,index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
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
                  ):Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("No Specialists"),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(appointmentTimeSelected==null){
                      final snackBar = SnackBar(content: Text("Please select a time slot"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    else{
                      AppointmentModel model=new AppointmentModel(
                        "",
                        username!,
                          FirebaseAuth.instance.currentUser!.uid,
                        f.format(_selectedDate).toString(),
                        appointmentTimeSelected!,
                          specialistId,
                          specialistName,
                        widget.model.id,
                        widget.model.name,
                        "Pending",
                        payment,
                        false,
                        false,
                        0,
                        amount.toString(),
                      );
                      Navigator.pushReplacement(context, new MaterialPageRoute(
                          builder: (context) => Checkout(model)));
                    }

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
    getTimeSlots();
    getSpecialists();
    setState(() {
      if(widget.isOffer){
        if(widget.isPercentage){
          print("dis ${widget.discount}");
          double percent=double.parse(widget.discount)/100;
          setState(() {
            amount=(double.parse(widget.model.price)*percent).toInt();
          });

        }
        else{
          setState(() {
            amount=(double.parse(widget.model.price)-double.parse(widget.discount)).toInt();
          });
        }
      }
      else
        amount=int.parse(widget.model.price);
    });
    FirebaseFirestore.instance.collection('customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          username=data['username'];
        });
      }
    });
  }
}

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
import 'package:spa_beauty/model/stripe_data.dart';
import 'package:spa_beauty/model/time_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/payment/payment-service.dart';
import 'package:spa_beauty/screens/checkout.dart';
import 'package:spa_beauty/utils/constants.dart';
class Reservation extends StatefulWidget {
  ServiceModel model;
  bool isOffer;
  String offerId;


  Reservation(this.model,this.isOffer,this.offerId);

  @override
  _ReservationState createState() => _ReservationState();
}


class _ReservationState extends State<Reservation> {

  bool monday=true,tuesday=true,wednesday=true,thursday=true,friday=true,saturday=true,sunday=true;

  List<TimeModel> time=[];
  String payment='Cash on delivery';
  int? amount;
  String? username;
  List<SpecialistModel> specialist=[];
  getSpecialists(){
    FirebaseFirestore.instance.collection('specialists')
        .where("serviceIds",arrayContains: widget.model.id).get().then((QuerySnapshot querySnapshot) {
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
    FirebaseFirestore.instance.collection('timeslots').where("serviceId" ,isEqualTo: widget.model.id).get().then((QuerySnapshot querySnapshot) {
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
  String packageName="none";
  String packageArName="none";
  String priceOfPackage="0";
  String packageId="none";
  String? langLocale;
  void checkLanguage(){
    String languageCode=context.locale.toLanguageTag().toString();
    languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
    if(languageCode=="US")
      langLocale="en_US";
    else
      langLocale="ar_EG";

  }
  @override
  Widget build(BuildContext context) {
    checkLanguage();
    final orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                      Align(
                          alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(12),
                          child:Text('select'.tr().toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  DatePicker(
                    DateTime.now(),
                    //locale: langu,
                    locale: langLocale!,
                    height: 120,
                    width: 80,
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
                    child: Text('availableSlot'.tr(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                  ),
                  isTimeLoading?
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ):
                  time.length==0?
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text('noTimeSlots'.tr()),
                  ):
                  Expanded(
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
                    child: Text('chooseSpecialist'.tr(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
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
                                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                  image: NetworkImage(specialist[index].image),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.all(10),
                            child: Text(specialist[index].name,style: TextStyle(color: Colors.white),),
                          ),
                        );
                      },
                    ):Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: Text('noSpecialist'.tr()),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      print("week day number ${_selectedDate.day}");
                      bool isDateAvailable=true;

                      final f = new DateFormat('dd-MM-yyyy');
                      String date=f.format(_selectedDate).toString();
                      String dayOfWeek=DateFormat('EEEE').format(_selectedDate);
                      print("week day name ${dayOfWeek}");
                      isDateAvailable=isWeekDayOn(dayOfWeek.toLowerCase());
                      await FirebaseFirestore.instance
                          .collection('off_dates')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                          if(date==data['date']){
                            isDateAvailable=false;
                          }
                        });
                      });


                      if(isDateAvailable){
                        if(appointmentTimeSelected==null){
                          final snackBar = SnackBar(content: Text("Please select a time slot"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else{
                          if(widget.model.hasPackages){
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
                                          padding: EdgeInsets.all(10),
                                          width: MediaQuery.of(context).size.width*0.3,
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance.collection('service_packages')
                                                .where("serviceId",isEqualTo: widget.model.id).snapshots(),
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
                                                    child: Text("No Packages Added",style: TextStyle(color: Colors.black))
                                                );

                                              }

                                              return new ListView(
                                                shrinkWrap: true,
                                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                  return new Padding(
                                                    padding: const EdgeInsets.only(top: 15.0),
                                                    child: ListTile(
                                                      onTap: (){
                                                        setState(() {
                                                          packageName=data['title'];
                                                          packageArName=data['title_ar'];
                                                          priceOfPackage=data['price'].toString();
                                                          packageId=document.reference.id;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      title: Text("${data['title']}",maxLines: 1,style: TextStyle(color: Colors.black),),


                                                  subtitle: Text(align=="Left"?"$symbol${data['priceOfPackage']}":"${data['priceOfPackage']}$symbol",maxLines: 1,style: TextStyle(fontSize:12,color: Colors.black),),
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                            );
                          }
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
                              widget.model.hasPackages?priceOfPackage:amount.toString(),
                              widget.isOffer?0:widget.model.points,
                              DateTime.now().millisecondsSinceEpoch,
                              _selectedDate.millisecondsSinceEpoch,
                              "",
                              "none",
                              "",
                              "",
                            widget.model.hasPackages?packageName:"none",
                            widget.model.hasPackages?packageArName:"none",
                            widget.model.hasPackages?packageId:"none",
                            widget.model.gender


                          );
                          if(widget.isOffer){
                            FirebaseFirestore.instance.collection('redeemedOffers').doc(FirebaseAuth.instance.currentUser!.uid)
                                .get().then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                List offers = data['offers'];
                                offers.add(widget.offerId);
                                FirebaseFirestore.instance.collection('redeemedOffers').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                  'offers':offers
                                });
                              }
                              else{
                                List offers=[];
                                offers.add(widget.offerId);
                                FirebaseFirestore.instance.collection('redeemedOffers').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                  'offers':offers
                                });
                              }
                            });

                          }

                          Navigator.push(context, new MaterialPageRoute(builder: (context) => Checkout(model)));
                        }
                      }
                      else{
                        final snackBar = SnackBar(content: Text("The date is not available"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
                      child:Text('book'.tr(),style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  String? symbol,align;
  initializeStripe() async {
    StripeData stripeData;
    await FirebaseFirestore.instance.collection('settings').doc('stripe').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        stripeData=new StripeData(
            data['publicKey'],
            data['secretKey'],
            data['mode'],
            data['merchantId']
        );
        StripeService.init(stripeData.pKey,stripeData.mode,stripeData.mId);
        StripeService.secret=stripeData.sKey;
      }
    });

  }
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('settings')
        .doc('week_days')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          monday=data['monday'];
          tuesday =data['tuesday'];
          wednesday=data['wednesday'];
          thursday=data['thursday'];
          friday =data['friday'];
          saturday=data['saturday'];
          sunday=data['sunday'];
        });
      }
    });
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
    initializeStripe();
    getTimeSlots();
    getSpecialists();
    setState(() {
      amount=int.parse(widget.model.price);
    });
    FirebaseFirestore.instance.collection('customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          username="${data['firstName']} ${data['lastName']}";
        });
      }
    });
  }
  bool isWeekDayOn(String day) {
    if (day == "monday") {
      if (monday)
        return true;
      else
        return false;
    }
    else if (day == "tuesday") {
      if (tuesday)
        return true;
      else
        return false;
    }
    else if (day == "wednesday") {
      if (wednesday)
        return true;
      else
        return false;
    }
    else if (day == "thursday") {
      if (thursday)
        return true;
      else
        return false;
    }
    else if (day == "friday") {
      if (friday)
        return true;
      else
        return false;
    }
    else if (day == "saturday") {
      if (saturday)
        return true;
      else
        return false;
    }
    else if (day == "sunday") {
      if (sunday)
        return true;
      else
        return false;
    }
    else
      return true;
  }

}

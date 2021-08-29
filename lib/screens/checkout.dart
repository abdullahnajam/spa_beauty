import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/appointment_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/payment/payment-service.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';

class Checkout extends StatefulWidget {
  AppointmentModel model;

  Checkout(this.model);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String payment='cardPayment'.tr();
  String couponId="";
  String? symbol,align;
  List ids=[];
  void back(){
    Navigator.pop(context);
  }
  String? amount;
  int pointForService=0;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('settings')
        .doc('points')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          pointForService=data['point'];
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
    setState(() {
      amount=widget.model.amount;
      print("amount $amount");
    });
  }

  final _formKey = GlobalKey<FormState>();
  var couponController=TextEditingController();
  payViaNewCard(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");

    await StripeService.payWithNewCard(
        amount: '15000',
        currency: 'USD'
    ).whenComplete(() {
      bookAppointment(true);
    });
    pr.close();

  }
  bookAppointment(bool paid){
    final f = new DateFormat('dd-MM-yyyy');
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('appointments').add({
      'name': widget.model.name,
      'amount':widget.model.amount,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'date': widget.model.date,
      'time': widget.model.time,
      'specialistId': widget.model.specialistId,
      'specialistName': widget.model.specialistName,
      'serviceId':widget.model.serviceId,
      'serviceName': widget.model.serviceName,
      'status': "Pending",
      'isRated':false,
      'rating':0,
      'points':pointForService,
      'paid':paid,
      'paymentMethod':payment=='cashPayment'.tr()?"Cash Payment":"Card Payment",
      'datePosted':DateTime.now().millisecondsSinceEpoch,
      'formattedDate':f.format(DateTime.now()).toString(),
      'day':DateTime.now().day,
      'month':DateTime.now().month,
      'year':DateTime.now().year,
    }).then((value) {
      pr.close();
      if(couponId!=""){
        ids.add(couponId);
        FirebaseFirestore.instance.collection('redeemedCoupons').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'coupons':ids
        });
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Your booking was successful',
        desc: 'Please wait for the approval of appointment',
        btnOkOnPress: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
        },
      )..show();
    }).onError((error, stackTrace) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error',
        desc: '${error.toString()}',
        btnOkOnPress: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Checkout(widget.model)));
        },
      )..show();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: (){
          if (_formKey.currentState!.validate()) {
            if(payment=='cardPayment'.tr())
              payViaNewCard(context);
            else if(payment=='cashPayment'.tr())
              bookAppointment(false);

          }
        },
        child: Container(
          color: lightBrown,
          height: MediaQuery.of(context).size.height*0.09,
          child: Center(child: Text('proceed'.tr(),style:TextStyle(
            color: Colors.white,
            fontSize: 22,
            //fontWeight: FontWeight.bold,
          ),)),
        ),
      ),
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
        child: SafeArea(
          child: ListView(
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
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('completeBooking'.tr()),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'confirmTheBookingDetail'.tr(),
                          style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            'service'.tr(),
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          Text(
                            "${widget.model.serviceName}",
                            style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            'date'.tr(),
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          Text(
                            "${widget.model.date}",
                            style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text(
                            'time'.tr(),
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          Text(
                            "${widget.model.time}",
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
                            'price'.tr(),
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          symbol==""?Container():

                          align=="Left"?
                          Text(
                            "$symbol$amount",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
                          ):
                          Text(
                            "$amount$symbol",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: darkBrown)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'addCoupon'.tr(),
                              style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller:couponController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: lightBrown,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                      color: lightBrown,
                                      width: 0.5
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: lightBrown,
                                    width: 0.5,
                                  ),
                                ),
                                hintText: 'enterCouponCode'.tr(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  amount=widget.model.amount;
                                  print("amount $amount");
                                });
                                int i=0;
                                FirebaseFirestore.instance.collection('coupons').where("code",isEqualTo: couponController.text.trim())
                                    .where("serviceId",isEqualTo: widget.model.serviceId).get().then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    setState(() {
                                      i++;
                                    });
                                    FirebaseFirestore.instance.collection('redeemedCoupons').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                                        List coupons=data['coupons'];
                                        ids=coupons;
                                        int counter=0;
                                        int totalLimit=int.parse(doc['usage']);
                                        for(int c=0;c<coupons.length;c++){
                                          if(coupons[c]==doc.reference.id){
                                            counter++;
                                          }
                                        }
                                        if(counter>=totalLimit){
                                          final snackBar = SnackBar(content: Text("Limit Exceeded"));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                        else{
                                          print("code ${doc['code']} ${widget.model.serviceId}");
                                          couponId=doc.reference.id;
                                          if(doc['discountType']=='Percentage'){
                                            double percent=double.parse(doc['discount'])/100;
                                            percent=double.parse(amount!)*percent;
                                            percent=double.parse(amount!)-percent;
                                            setState(() {
                                              amount=(percent).toString();
                                            });

                                          }
                                          else{
                                            setState(() {
                                              amount=(double.parse(amount!)-double.parse(doc['discount'])).toString();
                                            });
                                          }
                                        }
                                      }
                                      else{
                                        couponId=doc.reference.id;
                                        print("code ${doc['code']} ${widget.model.serviceId}");
                                        if(doc['discountType']=='Percentage'){
                                          double percent=double.parse(doc['discount'])/100;
                                          percent=double.parse(amount!)*percent;
                                          percent=double.parse(amount!)-percent;
                                          setState(() {
                                            amount=(percent).toString();
                                          });

                                        }
                                        else{
                                          setState(() {
                                            amount=(double.parse(amount!)-double.parse(doc['discount'])).toString();
                                          });
                                        }
                                      }
                                    });


                                  });
                                  if(i==0){
                                    final snackBar = SnackBar(content: Text("Invalid Code"));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });

                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: lightBrown,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                child: Text('redeem'.tr(),style: TextStyle(color: Colors.white,fontSize: 18),),
                              ),
                            )
                          ],
                        ),
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
                          items: <String>['cardPayment'.tr(),'cashPayment'.tr()]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),



                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

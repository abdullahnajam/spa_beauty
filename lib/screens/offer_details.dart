import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/offer_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class OfferDetail extends StatefulWidget {
  ServiceModel model;
  OfferModel offer;


  OfferDetail(this.model,this.offer);

  @override
  _OfferDetailState createState() => _OfferDetailState();
}


class _OfferDetailState extends State<OfferDetail> {
  void back(){Navigator.pop(context);}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: (){
      FirebaseFirestore.instance.collection('redeemedOffers').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          List offers = data['offers'];
          int counter = 0;
          int totalLimit = int.parse(widget.offer.usage);
          for (int c = 0; c < offers.length; c++) {
            if (offers[c] == widget.offer.id) {
              counter++;
            }
          }
          if (counter >= totalLimit) {
            final snackBar = SnackBar(content: Text("Limit Exceeded"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(widget.model, true,widget.offer.id)));
          }
        }
        else
          Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation(widget.model, true,widget.offer.id)));
          });
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
      body: SafeArea(
        child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(back, 'offerDetail'.tr()),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.offer.image,fit: BoxFit.cover,),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('offerTitle'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(widget.offer.name,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('description'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(widget.offer.description,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('service'.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('offer_service').where("offerId",isEqualTo: widget.offer.id ).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> offershot) {
                    if (offershot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text("Something Went Wrong")

                          ],
                        ),
                      );
                    }
                    if (offershot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (offershot.data!.size==0){
                      return Container(
                          alignment: Alignment.center,
                          child:Text("No Offer")

                      );

                    }
                    return new ListView(
                      shrinkWrap: true,
                      children: offershot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> serviceOffered = document.data() as Map<String, dynamic>;
                        //AboutModel model= AboutModel.fromMap(data, document.reference.id);
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: Text(serviceOffered['name'],style: TextStyle(color:Colors.black,fontSize: 12,fontWeight: FontWeight.w200),),
                        );
                      }).toList(),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

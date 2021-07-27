import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/values/constants.dart';


class ServiceDetail extends StatefulWidget {
  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height*0.33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft:Radius.circular(25) ),
                    image: DecorationImage(
                        image: AssetImage('assets/images/placeholder.png'),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: Icon(Icons.favorite_outlined,color: Colors.red,size: 25,),
                ),

                Positioned(
                  left: 20,
                  top: 40,
                  child: InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.arrow_back_ios_sharp,color:Colors.black54,size: 25,)),
                )
              ],
            ),

            SizedBox(
              height: size.height*0.02,
            ),

            Container(
              padding : EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              height: size.height*0.07,
              decoration: BoxDecoration(
                border: Border.all(color: darkBrown),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DefaultTabController(
                length: 3,
                child:Center(
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: lightBrown,
                      indicator : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightBrown,
                      ),
                      /*indicator:  UnderlineTabIndicator(
                          borderSide: BorderSide(width: 0.0,color: Colors.white),
                          insets: EdgeInsets.symmetric(horizontal:16.0)
                      ),*/

                      tabs: [
                        Tab(text: "Description"),
                        Tab(text: "Gallery"),
                        Tab(text: "Review"),
                      ],
                    ),
                )
              ),
            ),

          ],
        ),
      ),

      bottomNavigationBar:
      Container(
        color: lightBrown,
        height: size.height*0.09,
        child: Center(child: Text("BOOK NOW",style:TextStyle(
          color: Colors.white,
          fontSize: 22,
          //fontWeight: FontWeight.bold,
        ),)),
      ),

    );
  }
}

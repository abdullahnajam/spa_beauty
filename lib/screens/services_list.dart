import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class AllServicesList extends StatefulWidget {
  String catId,catName;

  AllServicesList(this.catId,this.catName);

  @override
  _AllServicesListState createState() => _AllServicesListState();
}

class _AllServicesListState extends State<AllServicesList> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: MenuDrawer(),
      key: _drawerKey,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(_openDrawer, widget.catName),
              Container(

                margin: EdgeInsets.all(10),
                child: Text("Find Best Services",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search),
                    SizedBox(
                      width: 5,
                    ),
                    Text('search'.tr())
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('services').where('categoryId', isEqualTo: widget.catId).snapshots(),
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
                      return Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/empty.png",width: 150,height: 150,),
                            Text("No Service Added")

                          ],
                        ),
                      );

                    }
                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        ServiceModel model= ServiceModel.fromMap(data, document.reference.id);
                        return new Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => ServiceDetail(model)));
                              },
                              child: Stack(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: new Column(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10)
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(data['image']),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          padding: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10)
                                            ),
                                          ),
                                          child: Text(data['name'],style: TextStyle(color: Colors.black),),
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      margin: EdgeInsets.only(top: 150),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: lightBrown),
                                          borderRadius: BorderRadius.circular(40)
                                      ),
                                      child: Text(data['price']),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

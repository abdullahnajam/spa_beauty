import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    child: Text('Notifications'),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').where('userId', whereIn: [FirebaseAuth.instance.currentUser!.uid,'all']).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something Went Wrong")

                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.size==0){
                    return Center(
                        child: Text("No Notifications")

                    );

                  }
                  return new ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                      return new Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: (){

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
      )
    );
  }
}

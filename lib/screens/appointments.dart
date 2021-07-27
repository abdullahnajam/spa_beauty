import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: MenuDrawer(),
      key: _drawerKey,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(_openDrawer,"Appointments"),
            Container(
              margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.47,
                    child:Text("Beauty Expert")
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.25,
                      child:Text("Description")
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                      child:Text("Status")
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: 2,
                itemBuilder: (BuildContext context,index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Container(),
                              ),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Specialist Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                  Text("Service",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),)
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.25,
                          child: Text("Description",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: darkBrown
                            ),
                            alignment: Alignment.center,
                            child: Text("Status",style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

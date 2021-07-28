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
  int option1 = 0 , option2 = 0 ;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: MenuDrawer(),
      key: _drawerKey,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(_openDrawer,"Appointments"),

            SizedBox(
              height: size.height*0.03,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height*0.055,
                  width: size.width*0.34,
                  child: RaisedButton(

                    color : option1 == 1 ?  lightBrown : Colors.white ,
                    textColor: option1 == 1 ?  Colors.white : Colors.black87 ,
                    child: Text('Upcoming'),

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    onPressed: () {
                      setState(() {
                        option1 = 1 ;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height*0.055,
                  width: size.width*0.34,
                  child: RaisedButton(
                    child: Text('Past'),
                    color : option1 == 2 ?  lightBrown : Colors.white ,
                    textColor: option1 == 2 ?  Colors.white : Colors.black87 ,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    onPressed: () {
                      setState(() {
                        option1 = 2 ;
                      });

                    },
                  ),
                ),
              ],
            ),

            SizedBox(
              height: size.height*0.025,
            ),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  SizedBox(
                    height : size.height*0.055,
                    width: size.width*0.2,
                    child: RaisedButton(
                      child: Text('All'),
                      color : option2 == 1 ?  lightBrown : Colors.white ,
                      textColor: option2 == 1 ?  Colors.white : Colors.black87 ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        setState(() {
                          option2 = 1 ;
                        });

                      },
                    ),
                  ),

                  SizedBox(
                    height : size.height*0.055,
                    width: size.width*0.34,
                    child: RaisedButton(
                      child: option1 == 1 ? Text('Approved') :Text('Completed') ,
                      color : option2 == 2 ?  lightBrown : Colors.white ,
                      textColor: option2 == 2 ?  Colors.white : Colors.black87 ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        setState(() {
                           option2 = 2 ;
                        });

                      },
                    ),
                  ),

                  SizedBox(
                    height : size.height*0.055,
                    width: size.width*0.34,
                    child: RaisedButton(
                      child: option1 == 1 ? Text('Pending') :Text('Cancelled'),
                      color : option2 == 3 ?  lightBrown : Colors.white ,
                      textColor: option2 == 3 ?  Colors.white : Colors.black87 ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        setState(() {
                           option2 = 3 ;
                        });
                      },
                    ),
                  ),
                ],
              ),

            SizedBox(
              height: size.height*0.02,
            ),

            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 1,
              color: Colors.black54,
            ),

            Container(
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
            )


          ],
        ),
      ),
    );
  }
}

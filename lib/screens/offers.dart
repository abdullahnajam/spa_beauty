import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
            CustomAppBar(_openDrawer, "Offers"),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context,index){
                  return InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),

                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/placeholder.png'),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("50% Off on a service",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 20,),
                                    Text("Coupon Code",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                    Text("1234567",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200),),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Valid Till Date",style: TextStyle(color: red),),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text("Details",style: TextStyle(color: red),),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_sharp,color: red,)
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
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

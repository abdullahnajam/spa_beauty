import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/widget/appbar.dart';
class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
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
            CustomAppBar(_openDrawer, "Coupons"),
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
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                                ),
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
                                 Text("50% Off",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                Text("Coupon Title",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                Text("Coupon Number : 000",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w200),),
                              ],
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

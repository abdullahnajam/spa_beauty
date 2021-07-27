import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
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
            CustomAppBar(_openDrawer, "Favourites"),
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
                            ListTile(
                              leading: CircleAvatar(
                                child:Container(),
                              ),
                              title: Text("Specialist Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                              subtitle:Text("Service",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                              trailing: Text("2 km",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("5"),
                                Container(height: 10, child: VerticalDivider(color: Colors.grey)),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 15,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 10,
                                    color: darkBrown,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  height: 25,
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: darkBrown
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Book Now",style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(width: 10,)

                              ],
                            ),
                            SizedBox(height: 10,)
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

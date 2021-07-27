import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/reservation.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/values/constants.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _drawerKey,
      drawer: MenuDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.45,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            darkBrown,
                            lightBrown,
                          ],
                        ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                    ),
                  ),
                  Container(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5,),
                                    Icon(Icons.place,color: Colors.white,),
                                    Text("Location",style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.white),)
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.menu,color: Colors.white,),
                                  onPressed: _openDrawer,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.63,
                                    height: 50,
                                    margin: EdgeInsets.only(right: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(40)
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
                                          Text("Search")
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset('assets/images/sort.png',width: 25,height: 25,),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset('assets/images/filter.png',width: 25,height: 25,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 2,
                                itemBuilder: (BuildContext context,index){
                                  return Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width*0.85,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/placeholder.png'),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  );
                                },
                              ),
                            )


                          ],
                        ),
                      )
                  )

                ],
              ),
            ),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context,index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                          ]
                      ),
                      height: 80,
                      width: 80,
                      margin: EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: "https://img.icons8.com/office/100/000000/spa-flower.png",
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            Text("Name", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                            ),)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Massages",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList()));
                          },
                          child: Text("View All",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: 2,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context,index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => Reservation()));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
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
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Service Title",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10,),
                                    Text("\$50.0",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
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
                                  ],
                                ),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 50,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text("Ad Banner Here"),
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

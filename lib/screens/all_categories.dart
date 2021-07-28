import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/search/search_category.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
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
              CustomAppBar(_openDrawer, "All Categories"),
              Container(

                margin: EdgeInsets.all(10),
                child: Text("Find Best Services",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              InkWell(
                onTap: ()async{
                  List<CategoryModel> category=[];
                  FirebaseFirestore.instance.collection('categories').get().then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      CategoryModel model=new CategoryModel(doc.reference.id, doc['name'], doc['image']);
                      setState(() {
                        category.add(model);
                      });
                    });
                  });
                  await showSearch<String>(
                    context: context,
                    delegate: CategorySearch(category),
                  );

                },
                child: Container(
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
                      Text("Search")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
                            Text("No Categories Added")

                          ],
                        ),
                      );

                    }
                    return new GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        CategoryModel model= CategoryModel.fromMap(data, document.reference.id);
                        return new InkWell(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => AllServicesList(model.id,model.name)));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: new Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)
                                        ),
                                        image: DecorationImage(
                                            image: NetworkImage(model.image),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: lightBrown,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(model.name,style: TextStyle(color: Colors.white),),
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

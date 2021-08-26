import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/select_gender.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/search/search_category.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/values/sharedPref.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
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
  void initState() {
    super.initState();
    sharedPref.getGenderImagePref().then((value){
      print("gender image $value");
      setState(() {
        genderImageUrl=value.toString();
      });
    });
  }

  void routing(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AllCategories()));

  }
  String genderImageUrl="";
  SharedPref sharedPref=new SharedPref();
  String? language;
  void checkLanguage(){
    String languageCode=context.locale.toLanguageTag().toString();
    languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
    if(languageCode=="US")
      language="English";
    else
      language="Arabic";
    print("language $language $languageCode");
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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(

            //color:Colors.transparent.withOpacity(0.2),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image:AssetImage("assets/images/pattern.jpg",),
                  fit: BoxFit.fitHeight

              )
          ),
          child: FutureBuilder<String>(
            future: sharedPref.getGenderPref(),
            builder: (context,prefshot){
              if (prefshot.hasData) {
                if (prefshot.data != null) {
                  print("shared ${prefshot.data}");
                  checkLanguage();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(_openDrawer, 'categories'.tr()),
                      Container(

                        margin: EdgeInsets.all(10),
                        child: Text('findTheBestService'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: ()async{
                                List<CategoryModel> category=[];
                                FirebaseFirestore.instance.collection('categories').get().then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                    CategoryModel model= CategoryModel.fromMap(data, doc.reference.id);
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
                                    Text('search'.tr())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectGender("Category")));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.15,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.network(genderImageUrl,width: 25,height: 25,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('categories')
                              .where("gender",isEqualTo: prefshot.data.toString()).snapshots(),
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
                  );
                }
                else {
                  return new Center(
                    child: Container(
                        child: Text("no data")
                    ),
                  );
                }
              }
              else if (prefshot.hasError) {
                return Text('Error : ${prefshot.error}');
              } else {
                return new Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ),
      ),
    );
  }
}

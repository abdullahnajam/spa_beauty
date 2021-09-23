import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_beauty/model/gender_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/screens/all_categories.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/utils/sharedPref.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectGender extends StatefulWidget {
  String screen;

  SelectGender(this.screen);

  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  PageController controller = PageController(
    initialPage: 0,
  );
  bool dataLoading=true;
  List<GenderModel> gender=[];
  void back(){Navigator.pop(context);}
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
  SharedPref sharedPref=new SharedPref();
  void showPopups(String gender){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context,setState){
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                insetAnimationDuration: const Duration(seconds: 1),
                insetAnimationCurve: Curves.fastOutSlowIn,
                elevation: 2,
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text("POPUP ADS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                )
                            )
                          ],
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('popups')
                                .where("gender",isEqualTo: gender)
                                .where("language",isEqualTo: language)
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                      Text("Something Went Wrong",style: TextStyle(color: Colors.black))

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
                                Navigator.pop(context);

                              }

                              return new ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                  return new Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: InkWell(
                                      onTap: ()async{
                                        await canLaunch(data['link']) ? await launch(data['link']) : throw 'Could not launch ${data['link']}';
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(language=="English"?data['title']:data['title_ar']),
                                          ),
                                          Image.network(
                                            data['image'],
                                            height: MediaQuery.of(context).size.height*0.7,
                                            width: MediaQuery.of(context).size.width,
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
                    )
                ),
              );
            },
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('genders').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GenderModel model=GenderModel(
          doc.reference.id,
          doc['gender'],
            doc['gender_ar'],
          doc['image']
        );
        setState(() {
          gender.add(model);
        });
      });
      setState(() {
        dataLoading=false;
      });
    });

  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    checkLanguage();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image:AssetImage("assets/images/pattern.jpg"),
              fit: BoxFit.fitHeight
            )
          ),
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
                      alignment: Alignment.center,
                      child: Text('chooseGender'.tr()),
                    ),
                    context.locale.languageCode=="en"?
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ):
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_sharp,color: darkBrown,),
                      ),
                    ),
                  ],
                ),
              ),
              dataLoading?
              Center(
                child: CircularProgressIndicator(),
              ):Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    margin: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height*0.8,
                    width: double.maxFinite,
                    child: PageView.builder(
                        controller: controller,
                        itemCount: gender.length,
                        itemBuilder: (context, position){
                          return Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                              Text(language=="English"?gender[position].gender:gender[position].gender_ar,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: darkBrown),),
                              Container(
                                height: MediaQuery.of(context).size.height*0.4,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius:  BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: gender[position].image,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),

                              ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                              InkWell(
                                onTap: (){
                                  SharedPref shared=SharedPref();
                                  shared.setGenderPref(gender[position].gender,gender[position].image);
                                  if(widget.screen=="Home"){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));

                                  }
                                  else if(widget.screen=="Category"){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AllCategories()));
                                  }
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.07,
                                  width: MediaQuery.of(context).size.width*0.7,
                                  decoration: BoxDecoration(
                                      color: darkBrown,
                                      border: Border.all(color: darkBrown,width: 2),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('chooseGender'.tr(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: gender.length,
                                  effect: WormEffect(dotWidth: 10,dotHeight:10,activeDotColor: darkBrown,dotColor: Colors.grey),
                                ),
                              ),
                            ],
                          );
                        }
                    ),
                  ),

                ],
              ),
            ],
          ),
        )
      )
    );
  }
}

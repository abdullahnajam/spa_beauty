import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_beauty/model/gender_model.dart';
import 'package:spa_beauty/navigator/bottom_navigation.dart';
import 'package:spa_beauty/values/constants.dart';
import 'package:spa_beauty/values/sharedPref.dart';
import 'package:spa_beauty/widget/appbar.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({Key? key}) : super(key: key);

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
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('genders').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GenderModel model=GenderModel(
          doc.reference.id,
          doc['gender'],
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
    return Scaffold(

      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
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
                      child: Text("Select Gender"),
                    )
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
                    height: MediaQuery.of(context).size.height*0.75,
                    width: double.maxFinite,
                    child: PageView.builder(
                        controller: controller,
                        itemCount: gender.length,
                        itemBuilder: (context, position){
                          return Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                              Text(gender[position].gender,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: darkBrown),),
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
                                  shared.setGenderPref(gender[position].gender);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
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
                                  child: Text("Select Gender",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
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

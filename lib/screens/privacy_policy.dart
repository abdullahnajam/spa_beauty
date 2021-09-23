import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/navigator/navigation_drawer.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:spa_beauty/search/search_category.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String privacy="",privacy_ar="";
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
    checkLanguage();
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

                    Align(
                      alignment: Alignment.center,
                      child: Text('privacy'.tr()),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  language=="English"?privacy:privacy_ar,
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
              ),
              

            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('settings')
        .doc('privacy')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          privacy=data['privacyPolicy'];
          privacy_ar=data['privacyPolicy_ar'];
        });
      }
    });
  }
}

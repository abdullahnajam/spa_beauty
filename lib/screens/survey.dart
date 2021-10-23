import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:spa_beauty/model/Survey_model.dart';
import 'package:spa_beauty/utils/constants.dart';
import 'package:spa_beauty/widget/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spa_beauty/utils/dark_mode.dart';
class Survey extends StatefulWidget {
  String username;


  Survey(this.username);

  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  void back(){
    Navigator.pop(context);
  }
  bool loadingComplete=false;
  List<SurveyModel> questions=[];
  void getAllQuestions()async{
   await FirebaseFirestore.instance.collection('survey').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        questions.add(SurveyModel.fromMap(data, doc.reference.id));
      });
    });

    setState(() {
      loadingComplete=true;
    });
  }
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    getAllQuestions();
  }
  var _suggestionController=TextEditingController();
  bool OpenSuggestionBox=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(back, 'survey'.tr()),
            if(loadingComplete)

                Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: !OpenSuggestionBox?
                PageView.builder(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, position) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,),
                        Text('question'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Text("${questions[position].question}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: questions[position].choices.length,
                            itemBuilder: (BuildContext context,int index){
                              return CheckboxListTile(
                                value: false,
                                  controlAffinity: ListTileControlAffinity.leading,
                                title: Text("${questions[position].choices[index]}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                                onChanged: (bool? value){
                                  print("position $position ${questions.length}");
                                  print("attempt ${questions[position].attempts} ${questions[position].id}");
                                  FirebaseFirestore.instance.collection("attempts").add({
                                    "userId": FirebaseAuth.instance.currentUser!.uid,
                                    "username": widget.username,
                                    "choice": questions[position].choices[index],
                                    "questionID": questions[position].id,
                                    "question": questions[position].question,
                                  });
                                  int attempts=int.parse(questions[position].attempts)+1;
                                  FirebaseFirestore.instance.collection("survey").doc(questions[position].id).update({
                                    "attempts": attempts.toString(),
                                  });
                                  int newIndex=position+=1;
                                  if(position<questions.length){
                                    pageController.animateToPage(newIndex, duration: Duration(seconds: 1), curve: Curves.easeIn);
                                  }
                                  else{
                                    setState(() {
                                      OpenSuggestionBox=true;
                                    });
                                  }

                                }
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: questions.length, // Can be null
                ):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('suggestion'.tr(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                      SizedBox(height: 10,),
                      TextFormField(
                        minLines: 3,
                        maxLines: 3,
                        controller: _suggestionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.5
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'enterSuggestion'.tr(),
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          child: RaisedButton(
                            color: darkBrown,
                            onPressed: ()async{
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Loading");
                              await FirebaseFirestore.instance.collection("suggestions").add({
                                "suggestion": _suggestionController.text,
                                "userId":FirebaseAuth.instance.currentUser!.uid,
                                "customerName":widget.username
                              });
                              pr.close();
                              Navigator.pop(context);
                            },
                            child: Text('submit'.tr(),style: TextStyle(color: Colors.white),),
                          )
                      ),
                    ],
                  ),
              )

            else
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}

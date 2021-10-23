import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel{
  String id,question,attempts;
  List choices;



  SurveyModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        question = map['question'],
        attempts = map['attempts'],
        choices= map['choices'];



  SurveyModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
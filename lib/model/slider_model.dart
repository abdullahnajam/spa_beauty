import 'package:cloud_firestore/cloud_firestore.dart';

class SliderModel{
  String id,image,language,gender;
  int position;



  SliderModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        position = map['position'],
        language = map['language'],
        gender = map['gender'];



  SliderModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
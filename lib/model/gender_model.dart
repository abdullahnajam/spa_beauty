import 'package:cloud_firestore/cloud_firestore.dart';

class GenderModel{
  String id,gender,gender_ar,image;


  GenderModel(this.id, this.gender, this.gender_ar, this.image);

  GenderModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        gender = map['gender'],
        gender_ar = map['gender_ar'],
        image = map['image'];



  GenderModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
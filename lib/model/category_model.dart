import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id,name,image;


  CategoryModel(this.id, this.name, this.image);

  CategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        image = map['image'];



  CategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
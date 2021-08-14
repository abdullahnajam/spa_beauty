import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id,name,name_ar,tags,image,gender;bool isFeatured;


  CategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        tags = map['tags'],
        image = map['image'],
        gender = map['gender'],
        isFeatured = map['isFeatured'];



  CategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);

  CategoryModel(this.id, this.name,this.name_ar, this.tags, this.image,this.gender,this.isFeatured);
}

class SubCategoryModel{
  String id,name,tags,image,mainCategory,mainCategoryId;


  SubCategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        tags = map['tags'],
        image = map['image'],
        mainCategory = map['mainCategory'],
        mainCategoryId = map['mainCategoryId'];



  SubCategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);

  SubCategoryModel(this.id, this.name, this.tags, this.image, this.mainCategory,
      this.mainCategoryId);
}
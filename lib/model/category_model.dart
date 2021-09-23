import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id,name,name_ar,tags,image,gender;bool isFeatured;
  bool isAllBranchs,isSubCategory;
  List branchIds;
  String mainCategoryName,mainCategoryNameAr,mainCategoryId;



  CategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        tags = map['tags'],
        image = map['image'],
        gender = map['gender'],
        isAllBranchs = map['isAllBranchs'],
        branchIds = map['branchIds'],
        isSubCategory = map['isSubCategory'],
        mainCategoryName = map['mainCategoryName'],
        mainCategoryNameAr = map['mainCategoryNameAr'],
        mainCategoryId = map['mainCategoryId'],
        isFeatured = map['isFeatured'];



  CategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);

  CategoryModel(this.id, this.name,this.name_ar, this.tags, this.image,this.gender,this.isFeatured,this.branchIds,this.isAllBranchs,
      this.isSubCategory,this.mainCategoryId,this.mainCategoryName,this.mainCategoryNameAr);
}


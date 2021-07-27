import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel{
  String id,name,image,gender,categoryName,categoryId,description;
  int rating;
  int totalRating;
  String price;


  ServiceModel(this.id, this.name, this.image, this.gender, this.categoryName,
      this.categoryId, this.rating, this.price,this.totalRating,this.description);

  ServiceModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        image = map['image'],
        gender = map['gender'],
        categoryName = map['categoryName'],
        categoryId = map['categoryId'],
        rating = map['rating'],
        price = map['price'],
        description = map['description'],
        totalRating = map['totalRating'];



  ServiceModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel{
  String id,name,name_ar,image,discount,startDate,endDate, usage,description,description_ar;


  OfferModel(
      this.id,
      this.name,
      this.name_ar,
      this.image,
      this.discount,
      this.startDate,
      this.endDate,
      this.usage,
      this.description,
      this.description_ar);

  OfferModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        image = map['image'],
        discount = map['discount'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        usage = map['usage'],
        description = map['description'],
        description_ar = map['description_ar'];



  OfferModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
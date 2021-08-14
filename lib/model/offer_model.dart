import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel{
  String id,name,image,discount,startDate,endDate, usage;


  OfferModel(
      this.id,
      this.name,
      this.image,
      this.discount,
      this.startDate,
      this.endDate,
      this.usage);

  OfferModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        image = map['image'],
        discount = map['discount'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        usage = map['usage'];



  OfferModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
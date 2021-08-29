import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialistModel{
  String id,name,name_ar,email,phone,image;bool status;
  List serviceIds;


  SpecialistModel(this.id, this.name,this.name_ar, this.email, this.phone, this.image, this.status,this.serviceIds);

  SpecialistModel.fromMap(Map<String,dynamic> map,String key)
      :id=key,
        name = map['name'],
        name_ar = map['name_ar'],
        email = map['email'],
        phone = map['phone'],
        serviceIds = map['serviceIds'],
        image = map['image'],
        status = map['status'];



  SpecialistModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
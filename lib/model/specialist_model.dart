import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialistModel{
  String id,name,email,phone,serviceName,serviceId,image,status;


  SpecialistModel(this.id, this.name, this.email, this.phone, this.serviceName,
      this.serviceId, this.image, this.status);

  SpecialistModel.fromMap(Map<String,dynamic> map,String key)
      :id=key,
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        serviceName = map['serviceName'],
        serviceId = map['serviceId'],
        image = map['image'],
        status = map['status'];



  SpecialistModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
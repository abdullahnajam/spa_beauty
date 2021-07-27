import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel{
  String id,name,location,phone;


  BranchModel(this.id, this.name, this.location, this.phone);

  BranchModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        location = map['location'],
        phone = map['phone'];



  BranchModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
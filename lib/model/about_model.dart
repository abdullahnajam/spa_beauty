import 'package:cloud_firestore/cloud_firestore.dart';

class AboutModel{
  String id,time,image,contact,description;



  AboutModel(this.id, this.contact, this.image,this.description,this.time);

  AboutModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        description = map['description'],
        contact = map['contact'],
        time = map['time'];



  AboutModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
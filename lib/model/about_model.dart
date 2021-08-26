import 'package:cloud_firestore/cloud_firestore.dart';

class AboutModel{
  String id,time,image,contact,description,description_ar,email;



  AboutModel(this.id, this.contact, this.image,this.description,this.description_ar,this.time,this.email);

  AboutModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        description = map['description'],
        description_ar = map['description_ar'],
        contact = map['contact'],
        time = map['time'],
        email = map['email'];



  AboutModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
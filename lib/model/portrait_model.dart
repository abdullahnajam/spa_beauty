import 'package:cloud_firestore/cloud_firestore.dart';

class PortraitModel{
  String id,linkId,type,name,image;


  PortraitModel(this.id, this.linkId, this.type, this.name, this.image);

  PortraitModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        image = map['image'],
        linkId = map['linkId'],
        type = map['type'],
        name = map['name'];



  PortraitModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
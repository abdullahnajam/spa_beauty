import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeModel{
  String id,userId,message;bool isRead;


  ChangeModel(this.id, this.userId,
      this.message, this.isRead);

  ChangeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        userId = map['userId'],
        message = map['message'],
        isRead = map['isRead'];



  ChangeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String id,title,type,detail,image,time,userId;bool everyone;


  NotificationModel(
      this.id, this.title, this.type, this.detail, this.image, this.time,this.userId,this.everyone);

  NotificationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        title = map['title'],
        type = map['type'],
        detail = map['detail'],
        image = map['image'],
        time = map['time'],
        userId = map['userId'],
        everyone = map['everyone'];



  NotificationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
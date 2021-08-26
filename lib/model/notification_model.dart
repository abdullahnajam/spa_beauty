import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String id,title,title_ar,type,type_ar,detail,detail_ar,image,time,userId,gender;bool everyone;


  NotificationModel(
      this.id, this.title,this.title_ar, this.type,this.type_ar, this.detail,this.detail_ar,this.gender, this.image, this.time,this.userId,this.everyone);

  NotificationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        title = map['title'],
        title_ar = map['title_ar'],
        type = map['type'],
        type_ar = map['type_ar'],
        detail = map['detail'],
        gender = map['gender'],
        detail_ar = map['detail_ar'],
        image = map['image'],
        time = map['time'],
        userId = map['userId'],
        everyone = map['everyone'];



  NotificationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
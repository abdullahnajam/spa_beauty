import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String username,email,phone,token,profilePicture,topic;
  int wallet,points;

  UserModel(this.username, this.email, this.phone, this.token,
      this.profilePicture, this.topic,this.points,this.wallet);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      :username = map['username'],
        email = map['email'],
        phone = map['phone'],
        token = map['token'],
        profilePicture = map['profilePicture'],
        topic = map['topic'],
        points = map['points'],
        wallet = map['wallet'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
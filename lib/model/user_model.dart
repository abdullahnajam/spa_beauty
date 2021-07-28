import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String username,email,phone,token,profilePicture,topic;

  UserModel(this.username, this.email, this.phone, this.token,
      this.profilePicture, this.topic);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      :username = map['username'],
        email = map['email'],
        phone = map['phone'],
        token = map['token'],
        profilePicture = map['profilePicture'],
        topic = map['topic'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
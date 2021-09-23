import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id,firstName,lastName,email,phone,token,profilePicture,topic,gender,status;
  int wallet,points;

  UserModel(this.id,this.firstName,this.lastName, this.email, this.phone, this.token,
      this.profilePicture, this.topic,this.points,this.wallet,this.gender,this.status);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        gender = map['gender'],
        email = map['email'],
        phone = map['phone'],
        token = map['token'],
        profilePicture = map['profilePicture'],
        topic = map['topic'],
        points = map['points'],
        status = map['status'],
        wallet = map['wallet'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
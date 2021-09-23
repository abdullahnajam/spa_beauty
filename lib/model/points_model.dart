import 'package:cloud_firestore/cloud_firestore.dart';

class PointModel{
  String review,shareService,shareApp;


  PointModel(this.review, this.shareService, this.shareApp);


  PointModel.fromMap(Map<String,dynamic> map)
      : review = map['point'],
        shareService = map['service'],
        shareApp = map['share'];



  PointModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}
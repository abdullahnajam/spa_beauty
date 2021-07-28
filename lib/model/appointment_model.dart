import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel{
  String id,name,userId,date,time,specialistId,specialistName,serviceId,serviceName,status;
  bool isRated;
  int rating;



  AppointmentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        userId = map['userId'],
        date = map['date'],
        time = map['time'],
        specialistId = map['specialistId'],
        specialistName = map['specialistName'],
        serviceId = map['serviceId'],
        serviceName = map['serviceName'],
        status = map['status'],
        isRated = map['isRated'],
        rating = map['rating'];




  AppointmentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
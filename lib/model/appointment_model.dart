import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel{
  String id,name,userId,date,time,specialistId,specialistName,serviceId,serviceName,status,paymentMethod,amount;
  bool isRated,paid;
  int datePosted;
  int rating,points;
  String place,placeId,branchName,branchId;



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
        rating = map['rating'],
        place = map['place'],
        placeId = map['placeId'],
        branchName = map['branchName'],
        branchId = map['branchId'],
        paid = map['paid'],
        paymentMethod = map['paymentMethod'],
        amount = map['amount'],
        datePosted = map['datePosted'],
        points = map['points'];


  AppointmentModel(
      this.id,
      this.name,
      this.userId,
      this.date,
      this.time,
      this.specialistId,
      this.specialistName,
      this.serviceId,
      this.serviceName,
      this.status,
      this.paymentMethod,
      this.isRated,
      this.paid,
      this.rating,
      this.amount,
      this.points,
      this.datePosted,
      this.placeId,
      this.place,
      this.branchId,
      this.branchName);

  AppointmentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
import 'package:cloud_firestore/cloud_firestore.dart';

class PopupModel{
  String id,title,title_ar,image,startDate,endDate,gender, language,link;


  PopupModel(this.id, this.title, this.title_ar, this.image, this.startDate,
      this.endDate, this.gender, this.language, this.link);

  PopupModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        title = map['title'],
        image = map['image'],
        title_ar = map['title_ar'],
        gender = map['gender'],
        language = map['language'],
        startDate = map['startDate'],
        endDate = map['endDate'],
        link = map['link'];



  PopupModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
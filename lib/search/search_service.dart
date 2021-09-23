import 'package:flutter/material.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/screens/services_list.dart';
import 'package:easy_localization/easy_localization.dart';
class ServiceSearch extends SearchDelegate<String> {
  final List<ServiceModel> service;
  String? result;
  String? language;
  ServiceSearch(this.service,this.language);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = service.where((service) {
      if(language=="English"){
        return service.name.contains(query);
      }
      else
        return service.name_ar.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            String languageCode=context.locale.toLanguageTag().toString();
            languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
            if(languageCode=="US")
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ServiceDetail(suggestions.elementAt(index),'English')));
            else
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              //subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = service.where((service) {
      if(language=="English"){
        return service.name.contains(query);
      }
      else
        return service.name_ar.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            String languageCode=context.locale.toLanguageTag().toString();
            languageCode="${languageCode[languageCode.length-2]}${languageCode[languageCode.length-1]}";
            if(languageCode=="US")
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ServiceDetail(suggestions.elementAt(index),'English')));
            else
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ServiceDetail(suggestions.elementAt(index),'Arabic')));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              //subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }
}
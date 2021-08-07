import 'package:flutter/material.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/model/service_model.dart';
import 'package:spa_beauty/screens/services_detail.dart';
import 'package:spa_beauty/screens/services_list.dart';

class ServiceSearch extends SearchDelegate<String> {
  final List<ServiceModel> service;
  String? result;

  ServiceSearch(this.service);

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
        close(context, result!);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = service.where((service) {
      return service.name.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ServiceDetail(suggestions.elementAt(index))));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(suggestions.elementAt(index).name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = service.where((service) {return service.name.contains(query);});

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ServiceDetail(suggestions.elementAt(index))));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(suggestions.elementAt(index).name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              subtitle: Text(suggestions.elementAt(index).categoryName,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),),

            ),
          ),
        );
      },
    );
  }
}
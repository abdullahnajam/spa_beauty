import 'package:flutter/material.dart';
import 'package:spa_beauty/model/category_model.dart';
import 'package:spa_beauty/screens/services_list.dart';

class CategorySearch extends SearchDelegate<String> {
  final List<CategoryModel> category;
  String? result;
  String? language;
  CategorySearch(this.category,this.language);

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
    final suggestions = category.where((category) {
      if(language=="English"){
        return category.name.contains(query);
      }
      else
        return category.name_ar.contains(query);

    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AllServicesList(suggestions.elementAt(index).id, language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar)));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = category.where((category) {
      if(language=="English"){
        return category.name.contains(query);
      }
      else
        return category.name_ar.contains(query);
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AllServicesList(suggestions.elementAt(index).id, language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar)));
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Image.network(suggestions.elementAt(index).image),
              ),
              title: Text(language=="English"?suggestions.elementAt(index).name:suggestions.elementAt(index).name_ar,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),

            ),
          ),
        );
      },
    );
  }
}
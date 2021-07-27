import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_beauty/values/constants.dart';
typedef void MyCallback();
class CustomAppBar extends StatefulWidget {
  final MyCallback callback;
  String title;

  CustomAppBar(this.callback, this.title);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.15, color: darkBrown),
        ),
      ),
      height:  AppBar().preferredSize.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){
                widget.callback();
              },
              icon: Icon(Icons.menu,color: darkBrown,),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(widget.title),
          )
        ],
      ),
    );
  }
}


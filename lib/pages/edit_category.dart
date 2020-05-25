import 'package:flutter/material.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/utils/category.dart';
import 'dart:convert' as JSON;

import '../main.dart';

class EditCategory extends StatefulWidget {
  Transwall _listener;
  Category _category;
  String _old;
  EditCategory(Transwall listener, Category category) {
    this._listener = listener;
    this._category = category;
    this._old = category.name;
  }

  @override
  State<StatefulWidget> createState() {
    return _EditCategoryState();
  }
}

class _EditCategoryState extends State<EditCategory> {
  String _newName = "";
  @override
  Widget build(BuildContext context) {
     final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Constants.maincolor,
        radius: 48.0,
        child: Icon(Icons.category,size: 65,color: Colors.white,),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          labelText: widget._category.name,
          labelStyle: TextStyle(color: Constants.maincolor),
          hintText: '\$Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onFieldSubmitted: (String str) {
        this._newName = str;
      },
    );

    final done = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            moveToLastScreen();
          },
          color: Constants.maincolor,
          child: Text(
            "Done",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: new Text("Edit Transaction"),
              backgroundColor: Constants.maincolor,
              centerTitle: false,
              elevation: 1.0,
            ),
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  logo,
                  SizedBox(
                    height: 48.0,
                  ),
                  name,
                  SizedBox(
                    height: 24.0,
                  ),
                  done
                ],
              ),
            ),
        )
            );
  }

  void moveToLastScreen() {
    widget._listener.categoryBackUpdate(_newName, widget._old);
    Navigator.pop(context);
  }
}

String copy(String s) {
  String result = "";
  result += s;
  return result;
}

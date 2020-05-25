import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrifty/menu/add_menu.dart';
import 'package:thrifty/pages/add_category.dart';
import 'package:thrifty/pages/add_transaction.dart';
import 'package:thrifty/pages/wallets.dart';
import 'package:thrifty/utils/category.dart';
import 'package:thrifty/pages/home.dart';

import '../main.dart';

class SelectCategory extends StatefulWidget {
  List<Category> _categories;
  Selected _listener;
  Transwall _sec;
  SelectCategory(this._categories, this._listener,this._sec);
  @override
  State<StatefulWidget> createState() {
    return _SelectCategoryState();
  }
}

class _SelectCategoryState extends State<SelectCategory> implements Cashed {
  Widget _buildRow(Category c, VoidCallback onTapped) {
    return ListTile(
      onTap: onTapped,
      title: new Text(
        c.name,
        style: TextStyle(
            color: Constants.maincolor, decorationColor: Colors.black),
      ),
    );
  }

  Widget _buildCategories() {
    return new ListView.builder(
      itemCount: widget._categories.length,
      itemBuilder: (context, index) {
        return _buildRow(widget._categories[index], () {
          widget._listener.categorySelected(widget._categories[index].name);
          Constants.categorieselect =widget._categories[index].name;
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //this gives the width of the screen
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: new Text("Categories"),
            backgroundColor: Constants.maincolor,
            centerTitle: false,
            elevation: 1.0,
            
          ),
          body: _buildCategories(),

          floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddCategory(widget._sec,this)));
                          
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Constants.maincolor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
         
        ));
  }

  @override
  void update(String cat,String iconname) {
    widget._categories.add(new Category(cat,iconname));
  }

 
}
abstract class Cashed{
   void update(String cat,String c);
}


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/edit_category.dart';
import 'package:thrifty/utils/category.dart';
import 'package:thrifty/pages/home.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:thrifty/utils/database.dart';



class Categories extends StatefulWidget {
  List<Category> _categories=Requirements.categories;
  Transwall _listener;
  Categories(this._listener);
  @override
  State<StatefulWidget> createState() {
    return _CategoriesState();
  }
}

class _CategoriesState extends State<Categories> {
  Widget _buildRow(Category c ) {


     return Slidable(
  delegate: new SlidableStrechDelegate(),
  actionExtentRatio: 0.25,

  child: new Container(
    height: 75,
    color: Colors.white,
    child: new ListTile(
      leading: new CircleAvatar(
        radius: 25,
        backgroundColor:  Colors.white,
        child: new Icon(Constants.iconss[c.iconname],size: 40,),
        foregroundColor:Constants.maincolor ,
      ),
      title: new Text(c.name),
      
    ),
  ),
  secondaryActions: <Widget>[
     new IconSlideAction(
      caption: 'Edit',
      color: Colors.blueGrey,
      icon: Icons.edit,
      onTap: () => {
         Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new EditCategory(widget._listener,c))
            )
      }
    ),new IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () => {
Alert(
      context: context,
      type: AlertType.warning,
      title: "Deleting Category : " + c.name,
      desc: "Are you sure about that?\n All related transactions will be deleted",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () =>{
          widget._listener.deleteCat(c),
          Navigator.pop(context)},
          width: 120,
        ),DialogButton(
          
          child: Text(
            "cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () =>
      {Navigator.pop(context)},
          width: 120,
        )
      ],
    ).show(),
         
      
      }
    ),
   
  ],
);
  }

 
  Widget _buildCategories() {
    if (widget._categories.length == 0) {
      print(getReqTrans(Dates.date_for_transactions).length);
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: <Widget>[
          Image.asset('assets/person.png',color: Constants.maincolor,),
          new Text("No Categories yet\nAdd one manually \nOR\n Ask google or siri to do it for you",style: TextStyle(color: Constants.maincolor,fontSize: 30),textAlign: TextAlign.center,)
        ],
      );
    } else {
      return new ListView.builder(
      itemCount: widget._categories.length,
      itemBuilder: (context, index) {
        return _buildRow(widget._categories[index]);
      },
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    //this gives the width of the screen
    final mediaQuerydata = MediaQuery.of(context);
    final size = mediaQuerydata.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: _buildCategories(),
      
    );
  }
}
@override
 Future deleteCat(Category ct) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.deleteCategory(ct.name);
    Requirements.transactions = await getDbTransactions();
    Requirements.wallets = await getDbWallets();
    Requirements.categories = await getDbCategories();
    
  }
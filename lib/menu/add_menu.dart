import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/pages/select_category.dart';
import 'package:thrifty/pages/select_wallet.dart';
import '../pages/add_wallet.dart';
import '../pages/add_transaction.dart';
import '../pages/add_category.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddMenu extends StatelessWidget{

  Transwall _listener;
  Cashed ccc;
  Cashed2 c;

  AddMenu(this._listener,this.ccc);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //add income
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(FontAwesomeIcons.wallet),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddWallet(_listener,c)));
                },
                child: new Text("Wallet"),
              ),
            )
          ],
        ),
        //add expense
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(FontAwesomeIcons.moneyBillWave),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  Constants.walletselect = "Select Wallet";
  Constants.categorieselect = "Select Category";
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddTransaction(_listener)));
                },
                child: new Text("Transaction"),
              ),
            )
          ],
        ),
        //add category
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(MdiIcons.basket),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddCategory(_listener,ccc)));
                          
                },
                child: new Text("Category"),
              ),
            )
          ],
        )
      ],
    );
  }

}
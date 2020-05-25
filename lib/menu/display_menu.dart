import 'package:flutter/material.dart';
import 'package:thrifty/pages/home.dart';
import '../pages/wallets.dart';
import '../pages/categories.dart';

class DisplayMenu extends StatelessWidget{

  Transwall _listener;
  DisplayMenu(this._listener);

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
              child: Icon(Icons.attach_money),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new Wallets(this._listener)));
                },
                child: new Text("Wallets"),
              ),
            )
          ],
        ),

        //add category
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.dashboard),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new Categories(this._listener)));
                },
                child: new Text("Categories"),
              ),
            )
          ],
        )
      ],
    );
  }

}
// might be deleted
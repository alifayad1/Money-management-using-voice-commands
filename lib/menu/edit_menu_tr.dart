import 'package:flutter/material.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/utils/transaction.dart';


class EditMenuTR extends StatelessWidget{

   TRansaction _transaction;
  Transwall _listener;

  EditMenuTR(this._listener, this._transaction);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
                //delete transaction
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.delete),
            ),
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: () {
                  _listener.deleteTransaction(_transaction);
                },
                child: new Text("Delete"),
              ),
            )
          ],
        )
      ],
    );
  }

}

//might be deleted
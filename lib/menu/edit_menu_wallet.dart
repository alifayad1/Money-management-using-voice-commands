import 'package:flutter/material.dart';
import 'package:thrifty/pages/edit_wallet.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/pages/wallets.dart';
import 'package:thrifty/utils/wallet.dart';


class EditMenuW extends StatelessWidget{

  Wallet _wallet;
  Transwall _listener;
  Cached _parent;
  int _index;
  EditMenuW(this._listener, this._wallet, this._parent, this._index);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //edit wallet
        new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.edit),
            )
            ,
            new Padding(
              padding: EdgeInsets.all(2.0),
              child: new MaterialButton(
                onPressed: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=> new EditWallet(_listener, _wallet)));
                },
                child: new Text("Edit"),
              ),
            )

          ],
        )
        ,

        //delete wallet
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
                  _listener.deleteWallet(_wallet);
                  _parent.update(this._index);
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

//might be deleted;
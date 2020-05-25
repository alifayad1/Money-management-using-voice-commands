import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/menu/edit_menu_wallet.dart';
import 'package:thrifty/pages/edit_wallet.dart';
import 'package:thrifty/pages/edit_wallet2.dart';
import 'package:thrifty/pages/edit_wallet2.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/utils/database.dart';
import 'package:thrifty/utils/wallet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Wallets extends StatefulWidget {
  List<Wallet> _wallets = Requirements.wallets;
  Transwall _listener;
  Wallets(this._listener);
  Wallet _wallet;
  // Transwall _listener;
  Cached _parent;
  int _index;
  @override
  State<StatefulWidget> createState() {
    return _WalletsState();
  }
}

// class _WalletsState extends State<Wallets> implements Updated{
class _WalletsState extends State<Wallets> implements Cached {
  Widget _buildRow(Wallet w, int index) {
    return Slidable(
      delegate: new SlidableStrechDelegate(),
      actionExtentRatio: 0.20,
      actions: <Widget>[
        new IconSlideAction(
            caption: 'substract',
            color: Colors.blueGrey,
            icon: Icons.edit,
            onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new EditWallet2(widget._listener, w)))),
      ],
      child: new Container(
        height: 75,
        color: Colors.white,
        child: new ListTile(
          leading: new CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white,
            child: new Icon(
              FontAwesomeIcons.wallet,
              size: 40,
            ),
            foregroundColor: Constants.maincolor,
          ),
          title: new Text(w.name),
          // subtitle: new Text("Created on " +tr.date.toString().substring(0, 16)+" deduced from "+tr.wallet),
          trailing: new Text(
            "\$" + w.balance.toString() + "/" + w.initial.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
            caption: 'Add to wallet',
            color: Colors.blueGrey,
            icon: Icons.edit,
            onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new EditWallet(widget._listener, w)))),
        new IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Deleting Wallet : " + w.name,
                    desc:
                        "Are you sure about that?\n All related transactions will be deleted",
                    buttons: [
                      DialogButton(
                        color: Colors.red,
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => {
                              widget._listener.deleteWallet(w),
                              Navigator.pop(context)
                            },
                        width: 120,
                      ),
                      DialogButton(
                        child: Text(
                          "cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => {Navigator.pop(context)},
                        width: 120,
                      )
                    ],
                  ).show(),
                  //
                }),
      ],
    );
  }

  Widget _buildWallets() {
    if (widget._wallets.length == 0) {
      print(getReqTrans(Dates.date_for_transactions).length);
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/person.png',
            color: Constants.maincolor,
          ),
          new Text(
            "No Wallets yet\nAdd one manually \nOR\n Ask google or siri to do it for you",
            style: TextStyle(color: Constants.maincolor, fontSize: 30),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else {
      return new ListView.builder(
        itemCount: widget._wallets.length,
        itemBuilder: (context, index) {
          return _buildRow(widget._wallets[index], index);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildWallets(),
    );
  }

  @override
  void update(int index) {
    setState(() {
      widget._wallets.removeAt(index);
    });
  }
}

abstract class Cached {
  void update(int index);
}

@override
Future deleteWallet(Wallet w) async {
  DatabaseHelper dh = DatabaseHelper.instance;
  await dh.deleteWallet(w.name);
  Requirements.transactions = await getDbTransactions();
  Requirements.wallets = await getDbWallets();
}

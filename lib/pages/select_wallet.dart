import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrifty/pages/add_transaction.dart';
import 'package:thrifty/pages/add_wallet.dart';
import 'package:thrifty/pages/edit_wallet.dart';
import 'package:thrifty/pages/home.dart';
import 'package:thrifty/pages/select_category.dart';
import 'package:thrifty/utils/wallet.dart';

import '../main.dart';

class SelectWallet extends StatefulWidget {
  List<Wallet> _wallets;
  Selected _listener;
  Transwall sec;
  Cashed2 upd;
  SelectWallet(this._wallets, this._listener,this.sec);
  @override
  State<StatefulWidget> createState() {
    return _SelectWalletState();
  }
}

class _SelectWalletState extends State<SelectWallet>implements Cashed2{
  Widget _buildRow(Wallet w, VoidCallback onTapped) {
    return ListTile(
      onTap: onTapped,
      title: new Text(
        w.name,
        style: TextStyle(
            color: Constants.maincolor, decorationColor: Colors.black),
      ),
      trailing: new Text(
        "\$" + w.balance.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWallets() {
    return new ListView.builder(
      itemCount: widget._wallets.length,
      itemBuilder: (context, index) {
        return _buildRow(widget._wallets[index], () {
          widget._listener.walletSelected(widget._wallets[index].name);
          Constants.walletselect =widget._wallets[index].name;
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
            title: new Text("Wallets"),
            backgroundColor: Constants.maincolor,
            centerTitle: false,
            elevation: 1.0,
           
          ),
          body: _buildWallets(),
           floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AddWallet(widget.sec,this)));
                          
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Constants.maincolor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          
        ));
  }
  @override
  void update(String cat,double bln,double intn) {
    widget._wallets.add(new Wallet(cat,bln,intn));
  }
}
abstract class Cashed2{
   void update(String cat,double t,double z);
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/select_category.dart';
import 'package:thrifty/pages/select_wallet.dart';
import 'home.dart';
import 'package:thrifty/utils/transaction.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flushbar/flushbar.dart';

class AddTransaction extends StatefulWidget {
  Transwall _listener;
  AddTransaction(this._listener);

  @override
  State<StatefulWidget> createState() {
    return _AddTransactionState();
  }
}

class _AddTransactionState extends State<AddTransaction> implements Selected {
  String _category;
  double _price = 0;
  String _wallet;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    ///INSERT THRIFTY LOGO
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('Dear thrifter'),
            content: new Text('$payload'),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Constants.maincolor,
        radius: 50.0,
        child: Icon(
          FontAwesomeIcons.cashRegister,
          size: 65,
          color: Colors.white,
        ),
      ),
    );

    final price = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
          hintText: '\$Price',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onFieldSubmitted: (String str) {
        _price = double.parse(str);
      },
      onSaved: (String str) {
        _price = double.parse(str);
      },
    );

    final category = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SelectCategory(
                      widget._listener.getCategories(), this,widget._listener)));
        },
        color: Colors.white,
        child: Text(
          Constants.categorieselect,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final wallet = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      new SelectWallet(widget._listener.getWallets(), this,widget._listener)));
        },
        color: Colors.white,
        child: Text(
          Constants.walletselect,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final done = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          onPressed: () {
            Constants.walletselect = "Select Wallet";
            Constants.categorieselect = "Select Category";
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

    return Scaffold(
      appBar: AppBar(
        title: new Text("Transaction"),
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
            price,
            SizedBox(
              height: 8.0,
            ),
            category,
            SizedBox(
              height: 8.0,
            ),
            wallet,
            SizedBox(
              height: 8.0,
            ),
            done
          ],
        ),
      ),
    );
  }

  Future _showNotification(String str, String titleNot, String payload2) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '$titleNot', '$str', platformChannelSpecifics,
        payload: '$payload2'); //insert how much remaining u need for example
  }

  void moveToLastScreen() async {
    if (_category != null && _price != 0 && _wallet != null && _price>0) {
      if (await widget._listener.transactionBack(new TRansaction(
          DateTime.now().toString(), _category, _price, _wallet))) {
        await _showNotification(
            "Happy thrifting", "Transaction completed", "Remaining balance:");
        Navigator.pop(this.context);
        if (Requirements.tip1.toString() == "false") {
          
          Navigator.pop(context);
          Flushbar(
                  duration: Duration(seconds: 5),
                  title: "TIP",
                  message:
                      "Did you know that thrifty supports slidable actions")
              .show(context);
          Requirements.tip1 = true;
        } else {
          Navigator.pop(context);
        }
      } else {
        await _showNotification(
            "You need more money to perform transaction (sorry mate your broke)",
            "Insufficient funds",
            "You need amount more to perform transaction");
        //Notification: No enough money __________________
      }
    } else {
      await _showNotification("Please insert transaction",
          "Transaction fields are empty", "You did not enter anything");
      //Notification: Fields are Empty ___________________
    }
  }

  
  @override
  void categorySelected(String category) {
    _category = category;
  }

  @override
  void walletSelected(String wallet) {
    _wallet = wallet;
  }
}

abstract class Selected {
  void walletSelected(String wallet);
  void categorySelected(String category);
}

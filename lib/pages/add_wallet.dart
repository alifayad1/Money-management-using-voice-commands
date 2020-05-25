import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/select_wallet.dart';
import 'package:thrifty/utils/wallet.dart';
import './home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class AddWallet extends StatefulWidget {
  Transwall _listener;
  
  Cashed2 update;
  AddWallet(this._listener,this.update);

  @override
  State<StatefulWidget> createState() {
    return _AddWalletState();
  }
}

class _AddWalletState extends State<AddWallet> {
  String _wallet;
  double _balance=0;
  double _initial = 0;

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
        child: Icon(FontAwesomeIcons.wallet,size: 65,color: Colors.white,),
      ),
    );

    final balance = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: true,
      decoration: InputDecoration(
          hintText: '\$Balance',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onFieldSubmitted: (String str) {
        _balance = double.parse(str);
        _initial = double.parse(str);
       
      },
    );

    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Wallet Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onFieldSubmitted: (String str) {
        _wallet = str;
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

    return Scaffold(
        appBar: AppBar(
          title: new Text("Wallet"),
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
              balance,
              SizedBox(
                height: 8.0,
              ),
              name,
              SizedBox(
                height: 24.0,
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
        payload: '$payload2');//insert how much remaining u need for example
  }

  moveToLastScreen() async {
    if (_wallet == null || _balance == 0.0) {
      //Notification: Fields are Empty ________________________________________________
      await _showNotification("Please fill empty field(s)", "Field(s) empty", "Thrifty is sure nameless wallets don't exist");
    } else if(_balance<0){
      await _showNotification("Sorry you are broke", "We can't borrow you money!", "Thrifty is sorry for you");
    }
    else{
      Wallet w = new Wallet(_wallet, _balance,_initial);
      
      await widget._listener.walletBack(w);
      Requirements.wallets = await getDbWallets();
         await _showNotification(
            "Happy thrifting", "Wallet Added", "Remaining balance:");
      if(widget.update!=null){
        widget.update.update(_wallet, _balance, _initial);
      }
      Navigator.pop(context);
    }
    
  }
}

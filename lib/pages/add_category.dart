import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/select_category.dart';
import 'package:thrifty/utils/category.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import './home.dart';

class AddCategory extends StatefulWidget {
  Transwall _listener;

  Cashed update;
  AddCategory(this._listener, this.update);

  @override
  State<StatefulWidget> createState() {
    return _AddCategoryState();
  }
}

class _AddCategoryState extends State<AddCategory> {
  String _category;
  String dropdownValue = 'default';

  

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
            title: new Text('Alert'),
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
        radius: 48.0,
        child: Icon(
          MdiIcons.basket,
          size: 65,
          color: Colors.white,
        ),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'enter item name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onFieldSubmitted: (String str) {
        _category = str;
      },
    );
    

    final cat = Center(
      //padding: EdgeInsets.symmetric(vertical: 16.0),

      child: DropdownButton<String>(
        value: dropdownValue,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['default','fruits', 'drinks', 'things', 'food','cars','animals','books','cloths']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
          .toList(),
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
        title: new Text("Category"),
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
            name,
            SizedBox(
              height: 24.0,
            ),
            
            new Center(child: new Row(children: <Widget>[SizedBox(
              height: 24.0,
            ),new Text("                           Select your icon :"),cat],))
            
            ,SizedBox(
              height: 24.0,
            ),
            done
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() async {
    if (_category != null) {
      await widget._listener.categoryBack(new Category(_category,dropdownValue));
      Requirements.categories = await getDbCategories();
      await _showNotification(
          "Happy thrifting", "category addition successful", " name added ");
      if(widget.update!=null){
      widget.update.update(_category,dropdownValue);}
      
      Navigator.pop(context);
    } else {
      await _showNotification("please insert category name :)", "Empty field",
          "Unless your going for a nameless category ;)");
      // Notification: Fields are empty ______________________________________________________________________________
    }
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
        payload: '$payload2'); //TELL USER WHICH CATEGORY THEY ADDED
  }
}

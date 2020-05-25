import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/menu/caltest.dart';
import 'package:thrifty/menu/statistics_menu.dart';
import 'package:thrifty/pages/categories.dart';
import 'package:thrifty/pages/select_category.dart';
import 'package:thrifty/utils/category.dart';
import 'package:line_icons/line_icons.dart';
import 'package:thrifty/utils/database.dart';
import 'package:thrifty/utils/wallet.dart';
import '../main.dart';
import '../menu/add_menu.dart';
import '../utils/transaction.dart';
import 'package:thrifty/pages/histogram.dart';
import 'package:thrifty/pages/wallets.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  Cashed ccc;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> implements Transwall, Updater {
  static const platform = const MethodChannel('app.channel.shared.data');
  @override
  void initState() {
    super.initState();
    getSharedText();
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      print(sharedData +
          "__________________________________________________________");
      //dataShared = sharedData;
      if (decomposeTr(sharedData) != null) {
        transactionBack(decomposeTr(sharedData));
      } else if (decomposeCt(sharedData) != null) {
        categoryBack(decomposeCt(sharedData));
      } else if (decomposeWt(sharedData) != null) {
        walletBack(decomposeWt(sharedData));
      }
      setState(() {});
      // print("_________________");
      // print(dataShared);
    } else {
      // print("_________________");
      // print(dataShared);
    }
  }

  Widget _buildRow(TRansaction tr, int index) {
    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        color: Colors.white,
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Constants.maincolor,
            child: new Text(
              (index + 1).toString(),
              style: TextStyle(fontSize: 25),
            ),
            foregroundColor: Colors.white,
          ),
          title: new Text(
            tr.category + " : \$" + tr.price.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: new Text("Created on " +
              tr.date.toString().substring(0, 16) +
              " deduced from " +
              tr.wallet),
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => Alert(
                context: context,
                type: AlertType.warning,
                title: "Deleting Transation",
                desc: "Are you sure about that",
                buttons: [
                  DialogButton(
                    color: Colors.red,
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () =>
                        {this.deleteTransaction(tr), Navigator.pop(context)},
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
        ),
      ],
    );
  }

  Widget _buildTransactions() {
    if (getReqTrans(Dates.date_for_transactions).length == 0) {
      print(getReqTrans(Dates.date_for_transactions).length);
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/person.png',
            color: Constants.maincolor,
          ),
          new Text(
            texttoget(),
            style: TextStyle(
                color: Constants.maincolor,
                fontSize: 30,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else {
      return new ListView.builder(
        itemCount: getReqTrans(Dates.date_for_transactions).length,
        itemBuilder: (context, index) {
          return _buildRow(
              getReqTrans(Dates.date_for_transactions)[index], index);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text("Thrifty : \$" + getTextp()),
        backgroundColor: Constants.maincolor,
        centerTitle: false,
        elevation: 1.0,
        actions: <Widget>[
          new CircularPercentIndicator(
            radius: 45,
            backgroundColor: Colors.white,
            progressColor: getColor(getpercent()),
            percent: getpercent(),
            animateFromLastPercent: true,
            animationDuration: 4,
            animation: true,
            center: new Text(
              (getpercent() * 100).roundToDouble().toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          new IconButton(
            iconSize: 30,
            icon: Icon(FontAwesomeIcons.calendarAlt),
            onPressed: () {
              Histogram.columnz = 0;
              showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                        title: new Text(
                          "Calendar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: new Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width*0.75,
                            child: Calendar(this)),
                      ));
              update();
            },
          ),
          new IconButton(
            iconSize: 30,
            icon: Icon(FontAwesomeIcons.info),
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.info,
                title: "TIPS",
                desc:
                    "Voice command supports the following :\n\n-create note I spent price \$ on category with wallet\n\n-Create note create category name\n\n-Create note create wallet name with price \$",
                buttons: [
                  DialogButton(
                    color: Constants.maincolor,
                    child: Text(
                      "COOL",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            },
          ),
          new IconButton(
            iconSize: 30,
            icon: Icon(FontAwesomeIcons.palette),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                        title: new Text(
                          "Paint your app",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: new Scaffold(
                          backgroundColor: Colors.white,
                          body: new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new IconButton(
                                  iconSize: 45,
                                  icon: Icon(FontAwesomeIcons.paintRoller,
                                      size: 45),
                                  color: Colors.indigo,
                                  onPressed: () async {
                                    _setindex(0);
                                    setState(() {
                                      Constants.maincolor = Colors.indigo;
                                      Navigator.pop(context);
                                    });
                                  }),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  _setindex(1);
                                  setState(() {
                                    Constants.maincolor = Colors.blueGrey;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.blue,
                                onPressed: () async {
                                  _setindex(2);
                                  setState(() {
                                    Constants.maincolor = Colors.blue;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.green,
                                onPressed: () async {
                                  _setindex(3);
                                  setState(() {
                                    Constants.maincolor = Colors.green;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.purple,
                                onPressed: () async {
                                  _setindex(4);
                                  setState(() {
                                    Constants.maincolor = Colors.purple;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.teal,
                                onPressed: () async {
                                  _setindex(5);
                                  setState(() {
                                    Constants.maincolor = Colors.teal;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.orangeAccent,
                                onPressed: () async {
                                  _setindex(6);
                                  setState(() {
                                    Constants.maincolor = Colors.orangeAccent;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.paintRoller,
                                    size: 45),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  _setindex(7);
                                  setState(() {
                                    Constants.maincolor = Colors.redAccent;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.moon, size: 45),
                                color: Colors.black,
                                onPressed: () async {
                                  _setindex(8);
                                  setState(() {
                                    Constants.maincolor = Colors.black;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              new IconButton(
                                iconSize: 45,
                                icon: Icon(FontAwesomeIcons.sun, size: 45),
                                color: Colors.yellow,
                                onPressed: () async {
                                  _setindex(9);
                                  setState(() {
                                    Constants.maincolor = Colors.yellow;
                                    Navigator.pop(context);
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ));
            },
          )
        ],
      ),
      body: new PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          _buildTransactions(),
          Container(
            child: StatisticsMenu(
                Requirements.transactions[Dates.date_for_pie_chart]),
            color: Colors.white,
          ),
          new Container(child: Wallets(this)),
          new Container(
            child: Categories(this),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                    title: new Text(
                      "Add",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: new Container(child: AddMenu(this, widget.ccc)),
                  ));
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Constants.maincolor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: Requirements.currentIndex,
        onTap: (index) {
          setState(() {
            Requirements.currentIndex = index;
            controller.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        hasInk: true,
        inkColor: Colors.black12,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Constants.maincolor,
              icon: Icon(
                FontAwesomeIcons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.home,
                color: Constants.maincolor,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Constants.maincolor,
              icon: Icon(
                FontAwesomeIcons.chartLine,
                color: Colors.black,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.chartLine,
                color: Constants.maincolor,
              ),
              title: Text("Statistics")),
          BubbleBottomBarItem(
              backgroundColor: Constants.maincolor,
              icon: Icon(
                FontAwesomeIcons.wallet,
                color: Colors.black,
              ),
              activeIcon: Icon(
                FontAwesomeIcons.wallet,
                color: Constants.maincolor,
              ),
              title: Text("Wallets")),
          BubbleBottomBarItem(
              backgroundColor: Constants.maincolor,
              icon: Icon(
                MdiIcons.basket,
                color: Colors.black,
              ),
              activeIcon: Icon(
                MdiIcons.basket,
                color: Constants.maincolor,
              ),
              title: Text("Items"))
        ],
      ),
    );
  }

  @override
  Future<bool> transactionBack(TRansaction transaction) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    bool ok = await dh.insertTransaction(transaction);
    Requirements.transactions = await getDbTransactions();
    Requirements.wallets = await getDbWallets();
    setState(() {});
    return ok;
  }

  @override
  Future walletBack(Wallet wallet) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.insertWallet(wallet);
    Requirements.wallets = await getDbWallets();
    setState(() {});
  }

  @override
  Future categoryBack(Category category) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.insertCategory(category);
    Requirements.categories = await getDbCategories();
    setState(() {});
  }

  @override
  Future walletBackUpdate(Wallet wallet) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.updateWallet(wallet.name, wallet.balance, wallet.initial);
    Requirements.wallets = await getDbWallets();
    Requirements.transactions = await getDbTransactions();
    setState(() {});
  }

  @override
  Future deleteTransaction(TRansaction tr) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.deleteTransaction(tr.date);
    Requirements.transactions = await getDbTransactions();
    Requirements.wallets = await getDbWallets();
    setState(() {});
  }

  @override
  List<Category> getCategories() {
    return Requirements.categories;
  }

  @override
  List<Wallet> getWallets() {
    return Requirements.wallets;
  }

  @override
  Future deleteWallet(Wallet w) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.deleteWallet(w.name);
    Requirements.transactions = await getDbTransactions();
    Requirements.wallets = await getDbWallets();
    setState(() {});
  }

  @override
  Future categoryBackUpdate(String newName, String old) async {
    if (newName.length > 0) {
      DatabaseHelper dh = DatabaseHelper.instance;

      await dh.updateCategory(old, newName);
      Requirements.categories = await getDbCategories();
      Requirements.transactions = await getDbTransactions();
      setState(() {});
    }
  }

  @override
  void update() {
    setState(() {});
  }

  @override
  Future deleteCat(Category ct) async {
    DatabaseHelper dh = DatabaseHelper.instance;
    await dh.deleteCategory(ct.name);
    Requirements.transactions = await getDbTransactions();
    Requirements.wallets = await getDbWallets();
    Requirements.categories = await getDbCategories();
    setState(() {});
  }
}

Future<Map<String, List<TRansaction>>> getDbTransactions() async {
  DatabaseHelper dh = DatabaseHelper.instance;
  return await dh.fulfillTransactions();
}

Future<List<Wallet>> getDbWallets() async {
  DatabaseHelper dh = DatabaseHelper.instance;
  return await dh.getWallets();
}

Future<List<Category>> getDbCategories() async {
  DatabaseHelper dh = DatabaseHelper.instance;
  return await dh.getCategories();
}

abstract class Transwall {
  void walletBack(Wallet wallet);
  void walletBackUpdate(Wallet wallet);
  Future<bool> transactionBack(TRansaction transaction);
  void categoryBack(Category category);
  void categoryBackUpdate(String newName, String old);
  void deleteTransaction(TRansaction tr);
  void deleteWallet(Wallet w);
  void deleteCat(Category tr);
  List<Category> getCategories();
  List<Wallet> getWallets();
}

double getpercent() {
  double x;
  if (Requirements.totalbalance.item1 != null &&
      Requirements.totalbalance.item2 != null) {
    x = Requirements.totalbalance.item2 /
        (Requirements.totalbalance.item1 + Requirements.totalbalance.item2);
  } else {
    x = 0;
  }
  return x;
}

getColor(double x) {
  if (x >= 0.9) {
    return Colors.red;
  } else if (x >= 0.8) {
    return Colors.orange;
  } else {
    return Colors.green;
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
_showNotification(String str, String titleNot, String payload2) async {
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

String getTextp() {
  if (Requirements.totalbalance.item1 == null) {
    return "0.0";
  } else
    return Requirements.totalbalance.item1.toString();
}

Future<int> _getindex() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int index = prefs.getInt('index') ?? 0;
  return index;
}

_setindex(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('index', index);
}

TRansaction decomposeTr(String text) {
  //print("TR");
  try {
    double price;
    String wallet;
    String category;
    String x = text;
    x = x.split("\$")[1]; //50 ...

    price = double.parse(x.split(" on ")[0]); //50
    x = x.split(" on ")[1]; //food ...

    category = x.split(" with ")[0]; //food
    x = x.split(" with ")[1]; //

    wallet = x.split(" ")[0];

    TRansaction tr = new TRansaction(DateTime.now().toString(),
        category.toLowerCase(), price, wallet.toLowerCase());
    return tr;
  } catch (e) {
    //print("Error_____________________" + e.toString());
  }
}

Category decomposeCt(String text) {
 // print("CT");
  try {
    String category;
    String x = text;
    category = x.split("category ")[1]; //50 ...

    Category ct = new Category(category, 'default');
    return ct;
  } catch (e) {
   // print("Error_____________________" + e.toString());
  }
}

Wallet decomposeWt(String text) {
  //print("WT");
  try {
    double balance, initial;
    String wallet;

    String x = text;
    x = x.split("wallet ")[1]; //50 ...

    wallet = x.split(" with ")[0];

    balance = double.parse(x.split(" with \$")[1]);
    initial = double.parse(x.split(" with \$")[1]); //50

    Wallet wt = new Wallet(wallet, balance, initial);
    return wt;
  } catch (e) {
    //print("Error_____________________" + e.toString());
  }
}

String texttoget() {
  if (Dates.date_for_transactions ==
      DateTime.now().toString().substring(0, 10)) {
    return "No transactions yet\nAdd one manually \nOR\n Ask google or siri to do it for you";
  } else {
    return "No transactions was made on this day";
  }
}

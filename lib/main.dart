import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrifty/utils/category.dart';
import 'package:thrifty/utils/database.dart';
import 'package:thrifty/utils/transaction.dart';
import 'package:thrifty/utils/wallet.dart';
import './pages/home.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/date_symbol_data_local.dart';



 
 
void main() async {
  DatabaseHelper dh = DatabaseHelper.instance;
  Requirements.transactions = await getDbTransactions();
  Requirements.wallets = await getDbWallets();
  Requirements.categories = await getDbCategories();
  Requirements.totalbalance = await getTotalBalance();
  Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions);
  Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
  Constants.walletselect = "Select Wallet";
  Constants.categorieselect = "Select Category";
  Requirements.piemap = await getmap(Requirements.categories);
  int x = await _getindex();
  Constants.maincolor = Constants.ourz[x];
  fillicons();
  



  

  
    
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  
  initializeDateFormatting().then((_) =>
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    
  )));
}

class Requirements {
  static Map<String,List<TRansaction>> transactions = new Map<String,List<TRansaction>>();
  static List<Wallet> wallets = new List<Wallet>();
  static List<Category> categories = new List<Category>();
  static Tuple2<double,double> totalbalance =new Tuple2(0, 0);
  static double totalperdate1 = 0;
  static double totalperdate2 = 0;
  static bool tip1 = false;
  static int currentIndex = 0;
  static PageController controller = PageController(initialPage: currentIndex);
  static Map<String,double> piemap = new Map();
  static int counter = 0;

 
  
  
  

}

List<TRansaction> getReqTrans(String d){
  List<TRansaction> result = new List();
  if(Requirements.transactions[d] != null) result = Requirements.transactions[d];
  return result; 
}

class Dates {

  static String date_for_transactions = DateTime.now().toString().substring(0,10);

  static String date_for_transactions1 = DateTime.now().toString().substring(0,10);
  static String date_for_transactions2 = getdate2();

  static String month1 = DateTime.now().toString().substring(0,7);
  static String month2 = getMonth2();
  static String date_for_pie_chart = DateTime.now().toString().substring(0,10);
}




class Constants {
  static Color maincolor = Colors.indigo;
  static Color secondarycolor = Colors.black;
  static Color barColor =  Colors.green;
  static List<Color> ourz= [Colors.indigo,Colors.blueGrey,Colors.blue,Colors.green,Colors.purple,Colors.teal,Colors.orangeAccent
  ,Colors.redAccent,Colors.black,Colors.yellow
  ];
  static String categorieselect = "Select Category";
  static String walletselect = "Select Wallet";


  static Map<String,IconData> iconss = new Map();
  
  

  
}

Future<int> _incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  await prefs.setInt('counter', counter);
  return counter;
}

Future<int> _getindex() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int index = prefs.getInt('index') ?? 0;
  return index;
}

_setindex(int index)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('index', index);
}

String getdate2(){
  if(DateTime.now().day!=1){

    return DateTime.now().toString().substring(0,8)+(DateTime.now().day-1).toString();

  }
  else{
      return DateTime.now().year.toString()+"-"+(DateTime.now().month-1).toString()+"-31";
  }
}

String getMonth2(){

  if(DateTime.now().month!=1){
    return DateTime.now().toString().substring(0,5)+(DateTime.now().month-1).toString();
  }else{
   return DateTime.now().year.toString() + "-12";
  }
}

void fillicons(){
  Constants.iconss['default'] = MdiIcons.fridge;
  Constants.iconss['fruits'] = FontAwesomeIcons.appleAlt;
  Constants.iconss['drinks'] = FontAwesomeIcons.beer;
  Constants.iconss['things'] = FontAwesomeIcons.boxes;
  Constants.iconss['food'] = FontAwesomeIcons.breadSlice;
  Constants.iconss['cars'] = FontAwesomeIcons.car;
  Constants.iconss['animals'] = FontAwesomeIcons.cat;
  Constants.iconss['books'] = FontAwesomeIcons.book;
  Constants.iconss['cloths'] = FontAwesomeIcons.tshirt;

}

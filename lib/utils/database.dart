import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:thrifty/main.dart';
import 'package:thrifty/main.dart' as prefix0;
import 'package:thrifty/utils/transaction.dart';
import 'package:thrifty/utils/category.dart';
import 'package:thrifty/utils/wallet.dart';
import 'package:tuple/tuple.dart';



class DatabaseHelper {
  static final _databaseName = "TheThrifters.db";
  static final _databaseVersion = 1;
  String path = "";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    //Wallet
    await db.execute(
        "CREATE TABLE Wallets(Wallet_name Text Primary key , Budget float,Initial float);");
    //Category
    await db
        .execute("CREATE TABLE Categories(Category_name Text Primary key,icon Text);");

    //Transaction
    await db.execute(
        "CREATE TABLE Transactions(Date Text Primary key,Category_name Text,Price float,Wallet_name Text,Foreign Key(Category_name) References Categories(Category_name) Foreign Key(Wallet_name) References Wallets(Wallet_name));"); //foreign keys

    
  }

//Insert Wallet
  Future<int> insertWallet(Wallet wallet) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert("Wallets", wallet.toMap());
    Requirements.totalbalance = await getTotalBalance();
     Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);

    return id;
  }

//Get Wallets

  Future<List<Wallet>> getWallets() async {
    List<Wallet> l = new List<Wallet>();
    Database db = await DatabaseHelper.instance.database;

    var result = await db.query(
        "Wallets");
 
    for (int i = 0; i < result.length; i++) {
      l.add(Wallet.fromMap(result[i]));
    }
    return l;
  }

  //delete wallet cascade 
  deleteWallet(String wallet_name) async {
    Database db = await DatabaseHelper.instance.database;

   await db.rawDelete("DELETE from Wallets where Wallet_name=\"$wallet_name\";"); 
   await db.rawDelete("DELETE from Transactions where Wallet_name=\"$wallet_name\";"); 
   
   Requirements.transactions = await fulfillTransactions(); 
   Requirements.totalbalance = await getTotalBalance();
   Requirements.piemap = await getmap(Requirements.categories);
  }



  deleteCategory(String cat_name) async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> q = await db.rawQuery(
        "SELECT Wallet_name,Price From Transactions where Category_name =\"$cat_name\";");
    
    if(q.isNotEmpty){
      String wallet_name = q[0]["Wallet_name"];
    double price = q[0]["Price"];
      await updateWalletAdd(wallet_name, price);
    }

    await db.rawDelete("DELETE from Transactions where Category_name =\"$cat_name\";"); 
   await db.rawDelete("DELETE from Categories where Category_name=\"$cat_name\";");
   
   
   Requirements.transactions = await fulfillTransactions(); 
   Requirements.categories = await getDbCategoriess();
   Requirements.totalbalance = await getTotalBalance();
   Requirements.piemap = await getmap(Requirements.categories);

  }

  //update wallet ---->add more money__________________________________________________________________________
  updateWallet(String wallet_name,double balance, double init) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate(
        "Update Wallets Set Budget=$balance Where Wallet_name=\"$wallet_name\";");
        await db.rawUpdate(
        "Update Wallets Set Initial=$init Where Wallet_name=\"$wallet_name\";");

    Requirements.totalbalance = await getTotalBalance();
    Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);
  }

  
//Insert Category
  Future<int> insertCategory(Category category) async {
    //when async function is called, the immediate result is a Future
    Database db = await DatabaseHelper.instance.database;

    int id = await db.insert(
        "Categories",
        category
            .toMap()); //await  makes you write the asynchronous code almost as if it were synchronous
    return id;
  }

  //update category 

  updateCategory(String name,String newName) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate(
        "Update Categories Set Category_name=\"$newName\" where Category_name=\"$name\";");
    await db.rawUpdate(
        "Update Transactions Set Category_name=\"$newName\" where Category_name=\"$name\";");
    Requirements.transactions = await fulfillTransactions();
     Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);
  }


//Get Categories

  Future<List<Category>> getCategories() async {
    List<Category> l = new List<Category>();
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> result = await db.query(
        "Categories"); 

    
    for (int i = 0; i < result.length; i++) {
      l.add(Category.fromMap(result[i]));
    }
    return l;
  }



//Insert Transaction

  Future<bool> insertTransaction(TRansaction transaction) async {
    Database db = await DatabaseHelper.instance
        .database; //await block until future type is complete and return what was inside the future
    bool boolean =
        await checkEnoughMoney(transaction.wallet, transaction.price);

    if (boolean) {
      await db.insert("Transactions", transaction.toMap());
      await subtractFromWallet(transaction.price, transaction.wallet);
      return boolean;
    }
    Requirements.transactions = await fulfillTransactions();
    Requirements.totalbalance = await getTotalBalance();
   Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);

    return boolean;

    
  }

  //delete transaction ---->add money to wallet
  deleteTransaction(String date) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> q = await db.rawQuery(
        "SELECT Wallet_name,Price From Transactions Where Date=\"$date\";");
    String wallet_name = q[0]["Wallet_name"];
    double price = q[0]["Price"];
    await db.rawDelete("Delete From Transactions Where Date=\"$date\";");
    await updateWalletAdd(wallet_name, price);
    Requirements.transactions = await fulfillTransactions();
    Requirements.totalbalance = await getTotalBalance();
     Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);
  }

updateWalletAdd(String wallet_name,double price) async{
Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate(
        "Update Wallets Set Budget=$price+Budget Where Wallet_name=\"$wallet_name\";");
    Requirements.totalbalance = await getTotalBalance();
    Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);
  }



//CHECK MONEY IN WALLET

  Future<bool> checkEnoughMoney(String name, double price) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> q = await db
        .rawQuery("SELECT Budget From Wallets Where Wallet_name=\"$name\";");

    double budget = q[0]["Budget"];

    if (budget - price < 0) {
      return false;
    }
    return true;
  }

//subtract Money from wallet

  subtractFromWallet(double price, String name) async {
    Database db = await DatabaseHelper.instance.database;

    await db.rawUpdate(
        "UPDATE Wallets Set Budget=Budget-$price Where Wallet_name=\"$name\";");

    Requirements.totalbalance = await getTotalBalance(); 
    Requirements.totalperdate1 = await getdayTranBalance(Dates.date_for_transactions1);
    Requirements.totalperdate2 = await getdayTranBalance(Dates.date_for_transactions2);
    Requirements.piemap = await getmap(Requirements.categories);
  }

  
Future<Map<String, List<TRansaction>>> fulfillTransactions() async {
    
    Set<String> dateset = new Set<String>();
    Database db = await DatabaseHelper.instance.database;

    var result = await db.rawQuery(
        "Select Distinct Date From Transactions"); 

    for (int i = 0; i < result.length; i++) {
      dateset.add(result[i]["Date"].toString().substring(0,10));
    }
    
    List<String> dates = dateset.toList();
    for (int i = 0; i < dates.length; i++) {
     
    }

    Map<String,List<TRansaction>> transactions = new Map();
    for(int i = 0; i < dates.length; i++){
      transactions[dates[i]] = await getTransactionsByDay(dates[i]);
    }
    return transactions;
  }


  Future<List<TRansaction>> getTransactionsByDay(String date) async {
    List<TRansaction> l = new List<TRansaction>();
    Database db = await DatabaseHelper.instance.database;

    var result = await db.query(
        "Transactions Where Date Like '$date%'"); 

    
    for (int i = 0; i < result.length; i++) {
      l.add(TRansaction.fromMap(result[i]));
 
    }
    return l;
  }

  Future<List<TRansaction>> getTransactionsByMonth(String year_month) async {
    List<TRansaction> l = new List<TRansaction>();
    Database db = await DatabaseHelper.instance.database;

    var result = await db.query(
        "Transactions Where Date Like '$year_month%'"); 

  
    for (int i = 0; i < result.length; i++) {
      l.add(TRansaction.fromMap(result[i]));
 
    }
    return l;
  }

  Future<List<TRansaction>> transactions_by_month(String date) async {
    String year_month = date.substring(0,7);
    List<TRansaction> result = await getTransactionsByMonth(year_month);
    return result;
  }



  Future<List<TRansaction>> transactions_by_day(String date) async {
    String day = date.substring(0,10);
    List<TRansaction> result = await getTransactionsByDay(day);
    return result;
  }
}
Future <Tuple2<double,double>> getTotalBalance() async{
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery("SELECT SUM(Budget) From Wallets");
    var result1 = await db.rawQuery("SELECT SUM(Price) from Transactions");
    Tuple2<double,double> t = new Tuple2(result[0]["SUM(Budget)"], result1[0]["SUM(Price)"]); 

    if(t.item1==null){
      t = new Tuple2(1, result1[0]["SUM(Price)"]);
    }
    if(t.item2==null){
      t = new Tuple2(result[0]["SUM(Budget)"], 0);

    }
    if(t.item1==null && t.item2==null){
      t = new Tuple2(1, 0);
    }
    
    return t;
  }

Future<double> getdayTranBalance(String date) async{
      Database db = await DatabaseHelper.instance.database;
      var result1 = await db.rawQuery("SELECT SUM(Price) from Transactions Where Date Like '$date%'");
      return result1[0]["SUM(Price)"];

}
Future<double> getCategoriesprice(String cat) async{
      Database db = await DatabaseHelper.instance.database;
      var result1 = await db.rawQuery("SELECT SUM(Price) from Transactions Where Category_name Like '$cat%'");
      return (result1[0]["SUM(Price)"]);
}

Future<Map<String,double>> getmap(List<Category> m) async{

   Map<String,double> mymap = new Map();

  for (var cat in m){
     
      
      if(await getCategoriesprice(cat.name)!=null){
        mymap[cat.name] = await getCategoriesprice(cat.name);
      }
   
  }
  if(mymap.isEmpty){
    mymap["NO DATA"] = 1;
  }
  return mymap;

}

Future<double> getmonthTranBalance(String year_month) async{
      Database db = await DatabaseHelper.instance.database;
      var result1 = await db.rawQuery("SELECT SUM(Price) from Transactions Where Date Like '$year_month%'");
      return result1[0]["SUM(Price)"];

}
Future<List<Category>> getDbCategoriess() async {
  DatabaseHelper dh = DatabaseHelper.instance;
  return await dh.getCategories();
}
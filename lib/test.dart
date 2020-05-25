// import 'package:flutter/material.dart';

// import 'package:sqflite/sqflite.dart';
// import 'package:thrifty/utils/category.dart';
// import 'package:thrifty/utils/wallet.dart';
// import 'package:thrifty/utils/database.dart';
// import 'package:thrifty/utils/transaction.dart';

// void main() async {
//   //always when using await u need to put async in the function to block the execution and finish the method call before continuing
//   Wallet wallet1 = new Wallet("Yoko", 100);
//   Wallet wallet2 = new Wallet("Ali", 1000);
//   Wallet wallet3 = new Wallet("Walid", 0);
//   Wallet wallet4 = new Wallet("Hsein", 2000);
//   Wallet wallet5 = new Wallet("Bdeir", 1111111111111.5);
//   Wallet wallet6 = new Wallet("Abou Bdeir", 999999999999999);

//   Category category1 = new Category("Food");
//   Category category2 = new Category("HouseHolds");
//   Category category3 = new Category("Utils");
//   Category category4 = new Category("Juice");
//   Category category5 = new Category("Car");
//   Category category6 = new Category("Internet");

//   TRansaction transaction1 =
//       new TRansaction(DateTime.now().toString(), "Food", 20, "Yoko");
//   TRansaction t = new TRansaction("l", "l", 1.0, "p");
  
//   TRansaction transaction2 =
//       new TRansaction(DateTime.now().toString(), "Car", 100000, "Bdeir");
//   TRansaction transaction3 =
//       new TRansaction(DateTime.now().toString(), "Utils", 1200, "Ali");
//   TRansaction transaction4 = 
//       new TRansaction(DateTime.now().toString(), "Gasoline", 12000, "Abou Bdeir");
//   TRansaction transaction5 =
//       new TRansaction(DateTime.now().toString(), "Internet", 900, "Hsein");
//   TRansaction transaction6 =
//       new TRansaction(DateTime.now().toString(), "Food", 30, "Yoko");
//   TRansaction transaction7 =
//       new TRansaction(DateTime.now().toString(), "Food", 90, "Yoko");

//   DatabaseHelper helper = DatabaseHelper.instance;
//   //insert wallets
//   await helper.insertWallet(wallet1);
//   await helper.insertWallet(wallet2);
//   await helper.insertWallet(wallet3);
//   await helper.insertWallet(wallet4);
//   await helper.insertWallet(wallet5);
//   await helper.insertWallet(wallet6);
//   //get wallets
//   print("wallets:");
//   List<Wallet> wallets= await helper.getWallets();
//   print("");
//   print("");
//   print("");
//   //insert category
//   await helper.insertCategory(category1);
//   await helper.insertCategory(category2);
//   await helper.insertCategory(category3);
//   await helper.insertCategory(category4);
//   await helper.insertCategory(category5);
//   await helper.insertCategory(category6);
//   //get categories
//   print("Categories:");
//   List<Category> categories= await helper.getCategories();
//   print("");
//   print("");
//   print("");
// //insert TRansaction
//   bool c = await helper.insertTransaction(
//       transaction3); //check if enough money true else not enough
//   bool a = await helper.insertTransaction(
//       transaction1); //check if enough money true else not enough
//   bool b = await helper.insertTransaction(
//       transaction2); //check if enough money true else not enough
//   bool d = await helper.insertTransaction(
//       transaction4); //check if enough money true else not enough
//   bool e = await helper.insertTransaction(
//       transaction5); //check if enough money true else not enough
//   bool f = await helper.insertTransaction(
//       transaction6); //check if enough money true else not enough
//   bool g = await helper.insertTransaction(
//       transaction7); //check if enough money true else not enough

//   //get TRansaction
//   print("TRansaction:");
//   List<TRansaction> transactions= await helper.getTransactions();
//   print("");
//   print("");
//   print("");
// //get wallets to see what happened after TRansaction
//   print("wallets:");
//   wallets=await helper.getWallets();//overriding the wallets list
// //update a wallet
//   //await helper.updateWallet("Yoko", 12000);
//   //get wallets to see the updates
//   wallets=await helper.getWallets();
//   print(wallets);

// //delete a transaction

//   // await helper.deleteTransaction("2019-03-23 01:15:01.449485");

//   //get TRansaction to see if it is deleted
//   print("Transaction:");
//   transactions = await helper.getTransactions();//overriding TRansaction list
//   print(transactions);
// }
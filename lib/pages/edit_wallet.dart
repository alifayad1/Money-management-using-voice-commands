import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:thrifty/utils/wallet.dart';
import '../main.dart';
import 'home.dart';

class EditWallet extends StatefulWidget{

  Transwall _listener;
  Wallet _wallet;
  EditWallet(this._listener, this._wallet);


  @override
  State<StatefulWidget> createState() {
    return _EditWalletState();
  }

}

class _EditWalletState extends State<EditWallet>{
  
  
  @override
  Widget build(BuildContext context) {
    
final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Constants.maincolor,
        radius: 50.0,
        child: Icon(MdiIcons.wallet,size: 65,color: Colors.white,),
      ),
    );

    final name =TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: widget._wallet.name.toString(),
        labelStyle: TextStyle(color: Constants.maincolor),
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
      onFieldSubmitted: (String str){
        widget._wallet.name = str;
      },
    );


    final balance =TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        labelText: "ammout to add",
        labelStyle: TextStyle(color: Constants.maincolor),
        hintText: '\$Balance',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
      onFieldSubmitted: (String str){
        widget._wallet.balance = widget._wallet.balance + double.parse(str);
        
        widget._wallet.initial = widget._wallet.initial +double.parse(str);
      },
    ); 

    

    

   
    final done =Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: (){
            moveToLastScreen();
          },
          color: Constants.maincolor,
          child: Text("Done", style: TextStyle(color: Colors.white) ,),

        ),
      ),    
    );



    return WillPopScope(
      
      onWillPop: (){
        Navigator.pop(context);
      },

      child: Scaffold(
      appBar: AppBar(
        title: new Text("Edit Transaction"),
        backgroundColor: Constants.maincolor,
        centerTitle: false,
        elevation: 1.0,
        
      )

      ,

      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0,right: 24.0),
          children: <Widget>[
            logo,
            // SizedBox(height: 48.0,),
            // name,
            SizedBox(height: 48.0,),
            balance,
            SizedBox(height: 24.0,),
            done
          ],
        ),
      )
      
      ,
    )
    );
  }

  
  void moveToLastScreen(){
    widget._listener.walletBackUpdate(widget._wallet);
    Navigator.pop(context);
  }
 

}
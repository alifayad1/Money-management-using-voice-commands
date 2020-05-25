class Wallet {
  String _name;
  double _balance;
  double _initial;

  Wallet(this._name, this._balance,this._initial);

  Wallet.Empty();

  get balance => this._balance;
  set balance(double b) => this._balance = b;
  get name => this._name;
  set name(String n) => this._name=n;

  get initial =>this._initial;
  set initial(double b) => this._initial = b;
  
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Wallet_name"] =
        _name; //key --> value  the key shoud be the same as attribute syntax
    map["Budget"] = _balance;
    map["Initial"] = _initial;
    return map;
  }

  static Wallet fromMap(Map<String, dynamic> map) {
    //this takes a list of Map

    Wallet w = Wallet.Empty();
    w._name = map["Wallet_name"];
    w._balance = map["Budget"];
    w._initial = map["Initial"];

    return w;
  }
}



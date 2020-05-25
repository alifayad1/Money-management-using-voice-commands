class TRansaction {
  String _category;
  double _price;
  String _date;
  String _wallet;

  TRansaction(this._date, this._category, this._price, this._wallet);
  TRansaction.Empty();

  String get category => this._category;
  String get wallet => this._wallet;
  double get price => this._price;
  String get date => this._date;

  set category(String c) => this._category = c;
  set wallet(String w) => this._wallet = w;
  set price(double p) => this._price = p;
  set date(String d) => this._date = d;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Date"] = _date;
    map["Category_name"] = _category;
    map["Price"] = _price;
    map["Wallet_name"] = _wallet;
    return map;
  }

  static TRansaction fromMap(Map<String, dynamic> map) {
    TRansaction t = TRansaction.Empty();
    t._date = map["Date"];
    t._category = map["Category_name"];
    t._price = map["Price"];
    t._wallet = map["Wallet_name"];

    return t;
  }
}

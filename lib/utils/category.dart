class Category {
  String _name;
  String iconname;
  Category(this._name, this.iconname);
  Category.Empty();
  String get name => _name;
  void set name(String n) => this._name=n;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Category_name"] =
        _name; 
        
    map["icon"] = iconname;//key --> value  the key shoud be the same as attribute syntax
    return map;
  }

  static Category fromMap(Map<String, dynamic> map) {
    Category c = Category.Empty();
    c._name = map["Category_name"];
    c.iconname = map["icon"];
    return c;
  }
}


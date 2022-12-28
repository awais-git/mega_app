class OptionGroup {
  String id;
  String name;
  int quantity;
  int selected;

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      // quantity = jsonMap['quantity'];
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'] : 1;
      selected = 0;
    } catch (e) {
      id = '';
      name = '';
      quantity = 0;
      selected = 0;
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["quantity"] = quantity;
    map["selected"] = selected;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}

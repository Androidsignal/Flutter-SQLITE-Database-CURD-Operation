class ProductModel {
  int id;
  String name;
  String price;
  String description;

  ProductModel({this.id, this.name, this.price, this.description});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'price': price,
      'description': description
    };
    return map;
  }

  ProductModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    description = map['description'];
  }
}

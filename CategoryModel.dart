import 'package:store_data_into_sqlite/ProductModel.dart';

class CategoryModel {
  String categoryName;
  String status;
  int time;
  int total;
  List<ProductModel> productList = new List<ProductModel>();

  CategoryModel.fromMap(Map<String, dynamic> map) {
    categoryName = map['categoryName'];
    status = map['status'];
    total = map['total'];
    time = map['time'];
  }
}

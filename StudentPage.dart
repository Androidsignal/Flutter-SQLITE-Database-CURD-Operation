import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_data_into_sqlite/CategoryModel.dart';
import 'package:store_data_into_sqlite/UpdatePage.dart';
import 'package:store_data_into_sqlite/ProductModel.dart';

import 'db_helper.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Future<List<ProductModel>> productList;

  List<CategoryModel> categories = new List<CategoryModel>();

  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshStudentList();
  }

  refreshStudentList() async {
    categories = await dbHelper.getCategories();
    setState(() {});
  }

  productListByStatus(String s) async {
    categories = await dbHelper.getShortByStatus(s);
    setState(() {});
  }

  productListByPrice(String s) async {
    categories = await dbHelper.getShortByPrice(s);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('SQLite CRUD in Flutter'),
          bottom: new PreferredSize(
            child: new Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: 60.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shortLayout(context);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Sort"),
                          SizedBox(width: 3.0),
                          Icon(Icons.import_export,
                              color: Colors.amber, size: 30.0),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        filterLayout(context);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Filter"),
                          SizedBox(width: 3.0),
                          Icon(Icons.swap_horizontal_circle,
                              color: Colors.amber, size: 30.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: new Size(56.0, 56.0),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  progressDialog(true, context);
                  callApiForData();
                  refreshStudentList();
                  progressDialog(false, context);
                })
          ],
        ),
        body: listView(categories),
      ),
    );
  }

  progressDialog(bool isLoading, BuildContext context) {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
          height: 40.0,
          child: new Center(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                Padding(padding: EdgeInsets.only(left: 15.0)),
                new Text("Please wait")
              ],
            ),
          )),
      contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    );
    if (!isLoading) {
      Navigator.of(context).pop();
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  Widget listView(List<CategoryModel> categories) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(categories[index].categoryName),
                  SizedBox(height: 5.0),
                  categoryProductList(categories, index),
                  SizedBox(height: 5.0),
                  Text("Status: " + categories[index].status),
                  SizedBox(height: 5.0),
                  Text("Total: " + categories[index].total.toString()),
                  SizedBox(height: 5.0),
                  Text("Time: " + categories[index].time.toString()),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          );
        });
  }

  categoryProductList(List<CategoryModel> categories, int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            List<Widget>.generate(categories[index].productList.length, (ii) {
          ProductModel pro = categories[index].productList[ii];
          return GestureDetector(
            onLongPress: () async {
              var a = await dbHelper.delete(pro.id);
              if (a == 1) {
                categories[index].productList.removeAt(ii);
                setState(() {});
              }
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(pro.id.toString()),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void shortLayout(context) {
    var sizes = 45.0;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Wrap(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                new ListTile(
                    leading: Icon(Icons.import_export,
                        color: Colors.amber, size: 30.0),
                    title: new Text('Short By'),
                    onTap: null),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Price Ascending'),
                    onTap: () {
                      progressDialog(true, context);
                      productListByPrice("ASC");
                      progressDialog(false, context);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Price Descending'),
                    onTap: () {
                      progressDialog(true, context);
                      productListByPrice("DESC");
                      progressDialog(false, context);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void filterLayout(context) {
    var sizes = 45.0;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Wrap(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                new ListTile(
                    leading: Icon(Icons.import_export,
                        color: Colors.amber, size: 30.0),
                    title: new Text('Filter By status'),
                    onTap: null),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Status Pending'),
                    onTap: () {
                      progressDialog(true, context);
                      productListByStatus("pending");
                      progressDialog(false, context);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Status Complete'),
                    onTap: () {
                      progressDialog(true, context);
                      productListByStatus("Complete");
                      progressDialog(false, context);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Status Cancle'),
                    onTap: () {
                      progressDialog(true, context);
                      productListByStatus("Cancle");
                      progressDialog(false, context);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future callApiForData() async {
    String result =
        await DefaultAssetBundle.of(context).loadString('assets/example.txt');
    print(result);
    Map resultData = json.decode(result);
    List orderList = resultData["Orders"];
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i]["products"].length; j++) {
        Map productMap = orderList[i]["products"][j];
        var map = <String, dynamic>{
          'name': productMap["title"],
          'price': productMap["price"].toString(),
          'description': productMap["description"],
          'categoryName': orderList[i]["category_name"],
          'status': orderList[i]["status"],
          'time': orderList[i]["time_in_minute"],
          'total': orderList[i]["Total"],
        };
        var id = await dbHelper.addProduct(map);
        print(id);
      }
    }
  }
}

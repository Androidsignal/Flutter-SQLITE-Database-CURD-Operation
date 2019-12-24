import 'package:flutter/material.dart';
import 'package:store_data_into_sqlite/StudentPage.dart';
import 'package:store_data_into_sqlite/ProductModel.dart';

import 'db_helper.dart';

class UpdatePage extends StatefulWidget {
  final ProductModel product;

  UpdatePage({this.product});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDecriptionController = TextEditingController();

  int studentIdForUpdate;

  DBHelper dbHelper;

  @override
  void initState() {
    dbHelper = DBHelper();
    if (widget.product != null) {
      productNameController.text = widget.product.name;
      productDecriptionController.text = widget.product.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update"),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Student Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    controller: productNameController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.purple,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Student Name",
                        labelText: "Student Name",
                        icon: Icon(
                          Icons.business_center,
                          color: Colors.purple,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.purple,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Description';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    controller: productDecriptionController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.purple,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Student Name",
                        labelText: "Product Description",
                        icon: Icon(
                          Icons.description,
                          color: Colors.purple,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.purple,
                        )),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Colors.purple,
            child: Text((widget.product != null ? 'UPDATE' : 'ADD'),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              /*if (widget.product != null) {
                if (_formStateKey.currentState.validate()) {
                  _formStateKey.currentState.save();
                  dbHelper.update(Product(
                      widget.product.id,
                      productNameController.text.toString(),
                      null,
                      productDecriptionController.text.toString()));
                  Navigator.of(context).pop(true);
                }
              } else {
                if (_formStateKey.currentState.validate()) {
                  _formStateKey.currentState.save();
                  dbHelper.add(Product(
                      null,
                      productNameController.text.toString(),
                      null,
                      productDecriptionController.text.toString()));
                  Navigator.of(context).pop(true);
                }
              }*/
            },
          ),
        ],
      ),
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_data_into_sqlite/CategoryModel.dart';
import 'package:store_data_into_sqlite/ProductModel.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'product.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE product (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price TEXT , description TEXT, categoryName TEXT, status TEXT, time INTEGER, total INTEGER)');
  }

  Future<int> addProduct(Map map) async {
    var dbClient = await db;
    int id = await dbClient.insert('product', map);
    return id;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    int a = await dbClient.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
    return a;
  }

  Future<int> update(ProductModel product) async {
    var dbClient = await db;
    return await dbClient.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<List<CategoryModel>> getShortByStatus(String status) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      'SELECT DISTINCT categoryname FROM product WHERE status = \"$status\"',
    );
    List<CategoryModel> categoryList = [];
    if (maps.length > 0) {
      categoryList = maps.map((c) => CategoryModel.fromMap(c)).toList();
    }
    for (int i = 0; i < categoryList.length; i++) {
      categoryList[i] = await getProductListByCategoryName(categoryList[i]);
    }
    return categoryList;
  }

  Future<List<CategoryModel>> getShortByPrice(String orderBy) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      'SELECT DISTINCT categoryname FROM product ORDER BY total $orderBy',
    );
    List<CategoryModel> categoryList = [];
    if (maps.length > 0) {
      categoryList = maps.map((c) => CategoryModel.fromMap(c)).toList();
    }
    for (int i = 0; i < categoryList.length; i++) {
      categoryList[i] = await getProductListByCategoryName(categoryList[i]);
    }
    return categoryList;
  }


  Future<List<CategoryModel>> getCategories() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      'SELECT DISTINCT categoryname FROM product',
    );
    List<CategoryModel> categoryList = [];
    if (maps.length > 0) {
      categoryList = maps.map((c) => CategoryModel.fromMap(c)).toList();
    }
    for (int i = 0; i < categoryList.length; i++) {
      categoryList[i] = await getProductListByCategoryName(categoryList[i]);
    }
    return categoryList;
  }

  Future<CategoryModel> getProductListByCategoryName(
      CategoryModel categoryModel) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      'SELECT * FROM product WHERE categoryname = \"${categoryModel.categoryName}\"',
    );

    List<ProductModel> productList = new List<ProductModel>();
    for (int i = 0; i < maps.length; i++) {
      Map map = maps[i];
      ProductModel product = ProductModel.fromMap(map);
      categoryModel = CategoryModel.fromMap(map);
      productList.add(product);
    }
    categoryModel.productList = productList;
    return categoryModel;
  }
}

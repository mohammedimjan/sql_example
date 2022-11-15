import 'package:sqflite_example/models/product_models.dart';
import 'package:sqflite_example/utils/db_helper.dart';

class DBService {
  Future<List<ProductModels>> getProducts() async {
    await DBHelper.init();

    List<Map<String, dynamic>> products =
        await DBHelper.query(ProductModels.table);

    return products.map((item) => ProductModels.fromMap(item)).toList();
  }

  Future<bool> addProduct(ProductModels models) async {
    await DBHelper.init();

    int ret = await DBHelper.insert(ProductModels.table, models);

    return ret > 0 ? true : false;
  }

  Future<bool> updateProduct(ProductModels models) async {
    await DBHelper.init();

    int ret = await DBHelper.update(ProductModels.table, models);

    return ret > 0 ? true : false;
  }

  Future<bool> deleteProduct(ProductModels models) async {
    await DBHelper.init();

    int ret = await DBHelper.delete(ProductModels.table, models);

    return ret > 0 ? true : false;
  }
}

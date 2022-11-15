import 'package:sqflite_example/models/model.dart';

class ProductModels extends Model {
  //this is the table name in sqflite
  static String table = "products";

  int? id;
  late int categoryId;
  late String productName;
  String? productDesc;
  double? productPrice;
  String? productPic;

  ProductModels({
    this.id,
    required this.productName,
    required this.categoryId,
    this.productPrice,
    this.productDesc,
    this.productPic,
  });

  static ProductModels fromMap(Map<String, dynamic> json) {
    return ProductModels(
      id: json['id'],
      productName: json['productName'].toString(),
      categoryId: json['categoryId'],
      productPrice: json['productPrice'],
      productDesc: json['productDesc'].toString(),
      productPic: json['productPic'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'productName': productName,
      'categoryId': categoryId,
      'productPrice': productPrice,
      'productDesc': productDesc,
      'productPic': productPic,
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
